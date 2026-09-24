
<h1>GIT Cheatsheet</h1>
<br />
<table>
  <thead style="text-align: left">
    <tr>
      <th>Action</th>
      <th>Command</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="width: 600px">
        View history of a function
        <br />
        <br />
        <a
          href="https://stackoverflow.com/questions/4781405/git-how-do-i-view-the-change-history-of-a-method-function"
        >
          https://stackoverflow.com/questions/4781405/git-how-do-i-view-the-change-history-of-a-method-function"
        </a>
        <br />
        <br />
        <a
          href="https://stackoverflow.com/questions/338436/how-can-i-view-an-old-version-of-a-file-with-git"
        >
          https://stackoverflow.com/questions/338436/how-can-i-view-an-old-version-of-a-file-with-git
        </a>
        <br />
        <br />
        e.g.
        <br />
        <code>git show HEAD~4:src/main.c</code>
      </td>
      <td class="tbl__td_command">
        <code>git log -L :{funcname}:{file}</code>
      </td>
    </tr>
    <tr>
      <td>Remove the file from the Git repository and the filesystem</td>
      <td>
        <code>git rm file1.txt</code>
      </td>
    </tr>
    <tr>
      <td>Remove file from Git repository and not filesystem</td>
      <td class="tbl__td_command">
        <code>git rm --cached file1.txt</code>
      </td>
    </tr>
    <tr>
      <td>
        Show git log compressed to one line per log entry with info
        <br />
        <br />
        <a
          href="https://stackoverflow.com/questions/1441010/the-shortest-possible-output-from-git-log-containing-author-and-date"
        >
          https://stackoverflow.com/questions/1441010/the-shortest-possible-output-from-git-log-containing-author-and-date
        </a>
        <p>
          To shorten the date (not showing the time) use --date=short In case you were curious what
          the different options were: %h = abbreviated commit hash %x09 = tab (character for code 9)
          %an = author name %ad = author date (format respects --date= option) %s = subject From
          kernel.org/pub/software/scm/git/docs/git-log.html (PRETTY FORMATS section) by comment of
          Vivek.
        </p>
      </td>
      <td class="tbl__td_command">
        <code>git log --pretty=format:"%h%x09%an%x09%ad%x09%s"</code>
      </td>
    </tr>
    <tr>
      <td>
        View previous version of file
        <br />
        <p style="font-style: italic; color: #666">
          Replace {REVISION} with your actual a Git commit SHA,
          <br />
          a tag name, a branchname, a relative commit name,
          <br />
          or any other way ofidentifying a commit in Git
        </p>
        <br />
        e.g. <code>git show HEAD~4:src/main.c</code>
        <br />
        <br />
        <a
          href="https://stackoverflow.com/questions/338436/how-can-i-view-an-old-version-of-a-file-with-git"
        >
          https://stackoverflow.com/questions/338436/how-can-i-view-an-old-version-of-a-file-with-git
        </a>
      </td>
      <td class="tbl__td_command">
        <code>git show {REVISION}:path/to/file</code>
      </td>
    </tr>
    <tr>
      <td>Remove local commit, keep changes</td>
      <td class="tbl__td_command">
        <code>git reset --soft HEAD^</code>
      </td>
    </tr>
    <tr>
      <td>
        Revert pushed commit
        <p style="font-style: italic; color: #666">
          This creates a new commit that reverts<br />
          the changes made in the bad commit.<br />
          Now push this to remote and you are good to go
        </p>
      </td>
      <td>
        <code>git revert {commit-hash}</code>
      </td>
    </tr>
    <tr>
      <td>Create annotated tag</td>
      <td class="tbl__td_command">
        <code>git tag -a v1.4 -m "my version 1.4"</code>
      </td>
    </tr>
  </tbody>
</table>
