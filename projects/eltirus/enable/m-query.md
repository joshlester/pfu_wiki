
## Query Backup

### Plant Run
```
let
    Source = Sql.Database("srv-eltirus-enable-01.database.windows.net", "db_eltirus_enable"),
    // Tables
    plants = Source{[Schema = "dbo", Item = "plants_plant"]}[Data],
    calendar = Source{[Schema = "dbo", Item = "calendar"]}[Data],
    plant_consent_hour = Source{[Schema = "dbo", Item = "plants_plant_consent_hour"]}[Data],
    downtime = Source{[Schema = "dbo", Item = "downtimes_downtime"]}[Data],
    downtime_entry = Source{[Schema = "dbo", Item = "downtimes_downtime_entry"]}[Data],
    downtime_entry_plant = Source{[Schema = "dbo", Item = "downtimes_downtime_entry_plant"]}[Data],
    plant_targets = Source{[Schema = "dbo", Item = "plants_plant_target_key_value"]}[Data],
    plant_measures = Source{[Schema = "dbo", Item = "plants_plant_measure_daily"]}[Data],
    plants_calendars = Source{[Schema = "dbo", Item = "plants_calendars"]}[Data],
    calendars_client_calendar_event = Source{[Schema = "dbo", Item = "calendars_client_calendar_event"]}[Data],
    plants_filtered = Table.SelectRows(plants, each [id] = 20),
    plants_cols = Table.SelectColumns(plants_filtered, {"id", "plant_id", "plant_name"}),
    // Create a list of dates for the last & current year
    StartDate = #date(Date.Year(DateTime.LocalNow()) - 1, 1, 1),
    EndDate = #date(Date.Year(DateTime.LocalNow()), 12, 31),
    DateList = List.Dates(StartDate, Duration.Days(EndDate - StartDate) + 1, #duration(1, 0, 0, 0)),
    // Expand the products table to include a row for each date
    plants_date = Table.AddColumn(plants_cols, "date", each DateList),
    plants_date_expanded = Table.ExpandListColumn(plants_date, "date"),
    plants_date_expanded_retyped = Table.TransformColumnTypes(plants_date_expanded, {{"date", type date}}),
    merge_plant_calendar = Table.NestedJoin(
        plants_date_expanded_retyped, {"date"}, calendar, {"date"}, "calendar", JoinKind.LeftOuter
    ),
    merge_plant_calendar_expanded = Table.ExpandTableColumn(
        merge_plant_calendar, "calendar", {"day_name"}, {"day_of_week"}
    ),
    merge_consent_hour = Table.NestedJoin(
        merge_plant_calendar_expanded,
        {"id", "day_of_week"},
        plant_consent_hour,
        {"plant_id", "day_of_week"},
        "consent_hours",
        JoinKind.LeftOuter
    ),
    merge_consent_hour_expanded = Table.ExpandTableColumn(
        merge_consent_hour, "consent_hours", {"time_start", "time_end"}, {"time_start", "time_end"}
    ),
    hours = Table.AddColumn(
        merge_consent_hour_expanded, "consent_hours", each Duration.TotalHours([time_end] - [time_start]), type number
    ),
    remove_consent_start_end_times = Table.RemoveColumns(hours, {"time_start", "time_end"}),
    // Create start date column which excludes time segment
    downtime_entries_with_date_only = Table.AddColumn(
        downtime_entry, "start_date", each DateTime.Date([start_datetime] + #duration(0, 13, 0, 0)), type date
    ),
    // Add plant id to downtime entry
    merge_downtime_entry_with_downtime_plant = Table.NestedJoin(
        downtime_entries_with_date_only,
        {"id"},
        downtime_entry_plant,
        {"downtime_entry_id"},
        "downtime_entry_plant",
        JoinKind.LeftOuter
    ),
    merge_downtime_entry_with_downtime_plant_expanded = Table.ExpandTableColumn(
        merge_downtime_entry_with_downtime_plant, "downtime_entry_plant", {"plant_id"}, {"plant_id"}
    ),
    merge_downtime_entry_with_downtime = Table.NestedJoin(
        merge_downtime_entry_with_downtime_plant_expanded,
        {"downtime_id"},
        downtime,
        {"id"},
        "downtime",
        JoinKind.LeftOuter
    ),
    merge_downtime_entry_with_downtime_expanded = Table.ExpandTableColumn(
        merge_downtime_entry_with_downtime, "downtime", {"reason", "type"}, {"reason", "type"}
    ),
    // Add downtime total
    // Add downtime total - Don't calculate downtime from manuly entered planned & unplanned downtime
    // Source from plant_daily_measures
    // downtime_total = Table.AddColumn(downtime_unplanned_in_hours, "downtime_total", each [downtime_planned] + [downtime_unplanned], type number),
    plant_measures_remove_nested_plant = Table.RemoveColumns(plant_measures, {"plants_plant"}),
    plant_measures_run_hours = Table.SelectRows(
        plant_measures_remove_nested_plant, each [measure_key] = "Tuakau/DailyLogs/RunHours"
    ),
    // TODO: Make generic.
    plant_measures_measured_on_date_transform = Table.TransformColumnTypes(
        plant_measures_run_hours, {{"measured_on", type date}}
    ),
    plant_measure_run_hours_join = Table.NestedJoin(
        remove_consent_start_end_times,
        {"date", "plant_id"},
        plant_measures_measured_on_date_transform,
        {"measured_on", "plant_id"},
        "run_hours",
        JoinKind.LeftOuter
    ),
    plant_measure_run_hours_join_expanded = Table.ExpandTableColumn(
        plant_measure_run_hours_join, "run_hours", {"value"}, {"run_hours"}
    ),
    downtime_total = Table.AddColumn(
        plant_measure_run_hours_join_expanded,
        "downtime_total",
        each
            if [consent_hours] = null or [run_hours] = null then
                null
            else if [consent_hours] - [run_hours] < 0 then
                0
            else
                [consent_hours] - [run_hours],
        type number
    ),
    // Add planned downtime
    downtime_planned = Table.SelectRows(merge_downtime_entry_with_downtime_expanded, each [type] = "PLANNED"),
    downtime_planned_total = Table.Group(
        downtime_planned,
        {"start_date", "plant_id"},
        {{"downtime_planned", each List.Sum([duration_in_mins]), type number}}
    ),
    merge_plant_downtime_planned = Table.NestedJoin(
        downtime_total, {"date", "id"}, downtime_planned_total, {"start_date", "plant_id"}, "downtime",
        JoinKind.LeftOuter
    ),
    merge_plant_downtime_planned_expanded = Table.ExpandTableColumn(
        merge_plant_downtime_planned, "downtime", {"downtime_planned"}, {"downtime_planned"}
    ),
    downtime_planned_in_hours = Table.ReplaceValue(
        merge_plant_downtime_planned_expanded,
        each [downtime_planned],
        each
            if [downtime_planned] = null or [downtime_planned] = 0 or [downtime_total] = null or [downtime_total] = 0
            then
                0
            else
                let
                    planned = [downtime_planned] / 60,
                    validPlanned = if [downtime_total] - planned > 0 then planned else [downtime_total]
                in
                    validPlanned,
        Replacer.ReplaceValue,
        {"downtime_planned"}
    ),
    downtime_planned_in_hours_retype = Table.TransformColumnTypes(
        downtime_planned_in_hours, {{"downtime_planned", type number}}
    ),
    // Add unplanned downtime
    downtime_unplanned = Table.SelectRows(merge_downtime_entry_with_downtime_expanded, each [type] = "UNPLANNED"),
    downtime_unplanned_total = Table.Group(
        downtime_unplanned,
        {"start_date", "plant_id"},
        {{"downtime_unplanned", each List.Sum([duration_in_mins]), type number}}
    ),
    merge_plant_downtime_unplanned = Table.NestedJoin(
        downtime_planned_in_hours_retype,
        {"date", "id"},
        downtime_unplanned_total,
        {"start_date", "plant_id"},
        "downtime",
        JoinKind.LeftOuter
    ),
    merge_plant_downtime_unplanned_expanded = Table.ExpandTableColumn(
        merge_plant_downtime_unplanned, "downtime", {"downtime_unplanned"}, {"downtime_unplanned"}
    ),
    downtime_unplanned_in_hours = Table.ReplaceValue(
        merge_plant_downtime_unplanned_expanded,
        each [downtime_unplanned],
        each
            if [downtime_unplanned] = null or [downtime_unplanned] = 0 or [downtime_total] = null or [downtime_total] = 0
            then
                0
            else
                let
                    unplanned = [downtime_unplanned] / 60,
                    validUnplanned =
                        if [downtime_total] - [downtime_planned] - unplanned > 0 then
                            unplanned
                        else
                            [downtime_total] - [downtime_planned]
                in
                    validUnplanned,
        Replacer.ReplaceValue,
        {"downtime_unplanned"}
    ),
    downtime_unplanned_in_hours_retype = Table.TransformColumnTypes(
        downtime_unplanned_in_hours, {{"downtime_unplanned", type number}}
    ),
    // Add uncoded downtime = Total Downtime (sourced from plant measures) - Planned Downtime - Unplanned Downtime
    //uncoded_downtime = Table.AddColumn(downtime_unplanned_in_hours, "downtime_uncoded", each [downtime_total] - [downtime_planned] - [downtime_unplanned], type number),
    uncoded_downtime = Table.AddColumn(
        downtime_unplanned_in_hours_retype,
        "downtime_uncoded",
        each
            if [downtime_total] = null or [downtime_total] - [downtime_planned] - [downtime_unplanned] < 0 then
                0
            else
                [downtime_total] - [downtime_planned] - [downtime_unplanned],
        type number
    ),
    // Source targets
    plant_id = if Table.RowCount(uncoded_downtime) > 0 then downtime_total{0}[id] else null,
    // Get plant ID
    plant_targets_filtered = Table.SelectColumns(plant_targets, {"plant_id", "target_key", "target_value"}),
    // Add available hours
    // Uncoded downtime is defaulted to planned downtime.
    available_hours = Table.AddColumn(
        uncoded_downtime, "available_hours", each [consent_hours] - [downtime_uncoded] - [downtime_planned], type number
    ),
    // Add actual hours - Actual hours = run_hours.
    // actual_hours = Table.AddColumn(available_hours, "actual_hours", each [consent_hours] - [downtime_total]), // Use downtime_total sourced from plant_daily_measures, not: [downtime_planned] - [downtime_unplanned]),
    // Add TPH target
    plant_target_tph = Table.SelectRows(plant_targets_filtered, each [plant_id] = plant_id and [target_key] = "TPH"),
    plant_target_tph_filtered = Table.SelectColumns(plant_target_tph, {"target_key", "target_value"}),
    target_value = plant_target_tph_filtered{0}[target_value],
    targets = Table.AddColumn(available_hours, "target_tph", each target_value, type number),
    // Add actual tph
    //plant_measures_remove_nested_plant = Table.RemoveColumns(plant_measures, {"plants_plant"}),
    plant_measure_tph = Table.SelectRows(plant_measures_remove_nested_plant, each [measure_key] = "rate"),
    plant_measure_tph_retyped = Table.TransformColumnTypes(plant_measure_tph, {{"measured_on", type date}}),
    plant_measure_tph_join = Table.NestedJoin(
        targets,
        {"date", "plant_id"},
        plant_measure_tph_retyped,
        {"measured_on", "plant_id"},
        "actual_tph",
        JoinKind.LeftOuter
    ),
    plant_measure_tph_join_expanded = Table.ExpandTableColumn(
        plant_measure_tph_join, "actual_tph", {"value"}, {"actual_tph"}
    ),
    // Get plant calendar to source calendar time off
    calendar_id =
        try Table.SelectRows(plants_calendars, each [plant_id] = plant_id){0}[client_calendar_id] otherwise null,
    plant_calendar_events =
        if calendar_id = null then
            Table.AddColumn(plant_measure_tph_join_expanded, "calender_time_off_in_mins", each 0)
        else
            let
                plant_calenar_events = Table.SelectRows(
                    calendars_client_calendar_event, each [calendar_id] = calendar_id
                ),
                // Filter all events to the plants calendar
                plant_calendar_events_add_column_event_on_date = Table.AddColumn(
                    calendars_client_calendar_event, "event_on_date", each DateTime.Date([event_on]), type date
                ),
                plant_calendar_events_grouped = Table.Group(
                    plant_calendar_events_add_column_event_on_date,
                    {"event_on_date"},
                    {
                        {
                            "duration_in_mins",
                            each List.Sum(List.Transform(_, each if [is_all_day] then 24 * 60 else [duration_in_mins])),
                            type number
                        }
                    }
                ),
                plant_calendar_events_join = Table.NestedJoin(
                    plant_measure_tph_join_expanded,
                    {"date"},
                    plant_calendar_events_grouped,
                    {"event_on_date"},
                    "calendar_events",
                    JoinKind.LeftOuter
                ),
                plant_calendar_events_expanded = Table.ExpandTableColumn(
                    plant_calendar_events_join, "calendar_events", {"duration_in_mins"}, {
                        "calendar_time_off_in_mins"
                    }
                )
            in
                plant_calendar_events_expanded,
    // Current if a calendar event exists for a given day, the duration in mins is ignored and the whole day is exclude (i.e. all oee metrics are zeroed out).
    // Performance
    performance = Table.AddColumn(
        plant_calendar_events,
        "performance",
        each if [calendar_time_off_in_mins] = null then [actual_tph] / [target_tph] else null,
        type number
    ),
    // Add utilisation
    // Uncoded downtime is defaulted to planned downtime.
    utilisation = Table.AddColumn(
        performance,
        "utilisation",
        each
            if [calendar_time_off_in_mins] = null then
                ([consent_hours] - [downtime_uncoded] - [downtime_planned]) / [consent_hours]
            else
                null,
        type number
    ),
    // Add availability
    availability = Table.AddColumn(
        utilisation,
        "availability",
        each if [calendar_time_off_in_mins] = null then [run_hours] / [available_hours] else null,
        type number
    ),
    // oee
    oee = Table.AddColumn(
        availability,
        "oee",
        each if [calendar_time_off_in_mins] = null then [performance] * [utilisation] * [availability] else null,
        type number
    ),
    remove_columns = Table.RemoveColumns(oee, {"plant_id", "plant_name", "day_of_week"}),
    renamed = Table.RenameColumns(remove_columns, {{"id", "plant_id"}}),
    #"Reordered Columns" = Table.ReorderColumns(
        renamed,
        {
            "date",
            "plant_id",
            "consent_hours",
            "run_hours",
            "available_hours",
            "downtime_total",
            "downtime_planned",
            "downtime_unplanned",
            "downtime_uncoded",
            "target_tph",
            "actual_tph",
            "calendar_time_off_in_mins",
            "performance",
            "utilisation",
            "availability",
            "oee"
        }
    ),
    #"Sorted Rows" = Table.Sort(#"Reordered Columns", {{"date", Order.Ascending}})
in
    #"Sorted Rows"

```