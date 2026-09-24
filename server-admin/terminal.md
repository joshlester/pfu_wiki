
# Terminal

## chmod
https://www.howtogeek.com/437958/how-to-use-the-chmod-command-on-linux/
>	0: (000) No permission.
    1: (001) Execute permission.
    2: (010) Write permission.
    3: (011) Write and execute permissions.
    4: (100) Read permission.
    5: (101) Read and execute permissions.
    6: (110) Read and write permissions.
    7: (111) Read, write, and execute permissions.

<table>
  <thead style="text-align: left;">
  <th>
    Action
    </th>
    <th>
      Command
    </th>
  </thead>
  <tbody>
    <tr>
      <td>
        Recursively remove read access for the <b><i>other</i></b>
        <br>
        group to all files ending with the <b><i>.page</i></b> extension
      </td>
      <td>
        <code>chmod -R o-r *.page</code>
      </td>
    </tr>
     <tr>
      <td>
        Add the execute permission for everyone
      </td>
      <td>
        <code>chmod a+x new_script.sh</code>
      </td>
    </tr>
  </tbody>
  </table>
  
  

## du (Disk Usage)
<br>
<table>
  <thead style="text-align: left;">
  <th>
    Action
    </th>
    <th>
      Command
    </th>
  </thead>
  <tbody>
    <tr>
      <td>
       Find largest folders in current folder
      </td>
      <td>
        <code>sudo du -hs * | sort -n -r | head -n 20</code>
      </td>
    </tr>
  </tbody>
    
  </table>
