#! /bin/bash

usage() { echo "Usage: sortieren [-c] [-n dir] [-d]" 1>&2; exit 1; }
help_msg() {
  echo -e "Usage: sortieren [-c] [-n dir] [-d]"
  echo -e "\t-h  show this help message"
  echo -e "\t-c  copy instead of move"
  echo -e "\t-n  name of sub directory"
  echo -e "\t-d  run second loop to extract images to delete"
}

# default arguments
dir_name="sortiert"
copy_files=false
delete_rest=false


while getopts "hcn:d" o; do
    case "${o}" in
        h)
            help_msg
            exit 0
            ;;
        c)
            copy_files=true
            ;;
        n)
            dir_name=${OPTARG}
            ;;
        d)
            delete_rest=true
            ;;
        *)
            echo "Wrong argument given"
            usage
            ;;
    esac
done

shift $((OPTIND-1))

if $copy_files
then
  echo "copy files"
  prog='cp'
else
  echo "move files"
  prog='mv'
fi

if [ $# -gt 0 ]
then
  echo "No Arguments supported"
  usage
fi

sxiv -to . >> tmp.txt

mkdir $dir_name
while IFS= read -r line
do
  $prog "$line" $dir_name
done < tmp.txt
rm tmp.txt

if $delete_rest
then
  mkdir delete
  sxiv -to . >> tmp.txt
  while IFS= read -r line
  do
    $prog "$line" delete
  done < tmp.txt
  rm tmp.txt
fi
