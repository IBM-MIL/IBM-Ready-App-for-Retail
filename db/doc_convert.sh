#
#  Licensed Materials - Property of IBM
#  © Copyright IBM Corporation 2015. All Rights Reserved.
#  This sample program is provided AS IS and may be used, executed, copied and modified without royalty
#  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to
#  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part
#  of such an application, in customer's own products.
#

# A script to convert JSON pulled via _all_docs to a format that can be re-uploaded.

# Acquire the first two arguments (input and output files).
input_file=$1; shift
output_file=$1; shift

# Did they ask for help?
if [[ "$input_file" == "-h" ]] || [[ "$output_file" == "-h" ]] ; then
  echo ""
  echo "Usage: ./doc_convert.sh [input file] [output file]"
  echo ""
  exit 1
fi

# Track the last line.
last_line=""

# Perform the data massaging.
while read -r json_line; do
    # Handle the first line.
    if [[ "${json_line:0:9}" == "{\"docs\":[" ]] || [[ "${json_line:0:14}" == "{\"total_rows\":" ]] ; then
        last_line="{\"docs\":["
        echo "$last_line" > $output_file
        
    # Handle the last line, if we can.
    elif [[ "${json_line:0:2}" == "]}" ]] ; then
        last_line="]}"
        echo -n "$last_line" >> $output_file
        
    # Standard case.
    else
        # Remove everything before the "doc".
        json_line="{${json_line#*\"doc\"\:\{}"
        
        # Snip the "_rev" out of what remains.
        json_prefix="${json_line%%\"\_rev\"*}"
        json_suffix="${json_line#*\"\_rev\"\:\"*\",}"
        json_line="$json_prefix$json_suffix"
        
        # Check to see if there's a comma at the end of the line, and act accordingly.
        if [[ "${json_line: -1}" == "," ]] ; then
            json_line="${json_line%\}*},"
        else
            json_line="${json_line%\}*}"
        fi
        
        # Output the line.
        echo "$json_line" >> $output_file
        last_line="$json_line"
    fi
done < $input_file

# Print out the final line, if it hasn't been printed already.
if [[ "$last_line" != "]}" ]] ; then
    echo -n "]}" >> $output_file
fi

exit 0
