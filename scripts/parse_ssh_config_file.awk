 #!/usr/bin/awk -f
function join(array, start, end, sep, result, i)
{
    # https://www.gnu.org/software/gawk/manual/html_node/Join-Function.html
    if (sep == "")
    sep = " "
    else if (sep == SUBSEP) # magic value
    sep = ""
    result = array[start]
    for (i = start + 1; i <= end; i++)
    result = result sep array[i]
    return result
}

function parse_line(line)
{
    n = split(line, line_array, " ")

    key = line_array[1]
    value = join(line_array, 2, n)

    return key "#-#" value
}

BEGIN {
    IGNORECASE = 1
    FS="\n"
    RS=""

    host_list = ""
}
{
    host_name = ""
    alias = ""
    desc = ""
    desc_formated = ""

    for (line_num = 1; line_num <= NF; ++line_num) {
    line = parse_line($line_num)

    split(line, tmp, "#-#")

    key = tmp[1]
    value = tmp[2]

    if (key == "Host") { alias = value }
    if (key == "Hostname") { host_name = value }
    if (key == "#_Desc") { desc = value }
    }

    if (!host_name && alias ) {
        host_name = alias
    }

    if (desc) {
        desc_formated = sprintf("[\033[00;34m%s\033[0m]", desc)
    }

    if ((host_name && host_name != "*") || (alias && alias != "*")) {
        host = sprintf("%s|->|%s|%s\n", alias, host_name, desc_formated)
        host_list = host_list host
    }
}
END {
    print host_list
}