 #!/usr/bin/awk -f
 {
    if (NF == 2 && tolower($1) == "include")
    {
        cmd = "cat " $2 " 2> /dev/null"
        # print cmd
        # cmd | getline line
        while ( (cmd | getline line) > 0 ) {
        print line
        }
        close($2)
    }
    else {
        print
    }
}