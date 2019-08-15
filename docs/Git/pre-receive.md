## pre-receive eslint

git服务端对提交的vue，js代码进行eslint检查，不通过则不允许提交

```shell
#!/bin/bash

export PATH=$PATH:/home/node-v10.16.0-linux-x64/bin/

TEMPDIR=`mktemp -d`
ESLINTRC=/tmp/.eslintrc.js
COMMAND="eslint --color -c $ESLINTRC --rule 'import/no-unresolved: 0' --rule 'import/no-duplicates: 0' --rule 'import/export: 0'"
SRC='src'

git show HEAD:.eslintrc.js > $ESLINTRC


echo "### Ensure changes follow our code style... ####"

# See https://www.kernel.org/pub/software/scm/git/docs/githooks.html#pre-receive
oldrev=$1
newrev=$2
refname=$3
NULL_COMMIT=$(printf '0%.0s' {1..40})

while read oldrev newrev refname; do
  if [[ "$newrev" = $NULL_COMMIT ]]; then
    # branch deleted
    continue;
  fi

  if [[ "$oldrev" = $NULL_COMMIT ]]; then
    # new branch created
    oldrev=HEAD
  fi

  # Get the file names, without directory, of the files that have been modified
  # between the new revision and the old revision
  files=`git diff --name-only ${oldrev}..${newrev}`

  # Get a list of all objects in the new revision
  objects=`git ls-tree --full-name -r ${newrev}`

  for file in $files; do
    # only eslint file in the src
    result=$(echo ${file} | grep "${SRC}")
    if [[ "${result}"x = "x" ]]
    then
      continue
    fi
    # Search for the file name in the list of all objects
    object=`echo -e "${objects}" | egrep "(\s)${file}\$" | awk '{ print $3 }'`

    # If it's not present, then continue to the the next itteration
    if [ -z ${object} ]; then
      continue;
    fi

    # Otherwise, create all the necessary sub directories in the new temp directory
    mkdir -p "${TEMPDIR}/`dirname ${file}`" &>/dev/null
    # and output the object content into it's original file name
    git cat-file blob ${object} > ${TEMPDIR}/${file}
  done
done

# lint js files
files_found=`find ${TEMPDIR} \( -name '*.js' -o -name '*.vue' \) | xargs echo -n`
resulting_status=0

if [ ${#files_found} -ne 0 ]; then
  results=`eval "$COMMAND $files_found"`
  resulting_status=$?
  #echo "$COMMAND $files_found"
  echo "$results" | sed "s/${TEMPDIR//\//\\/}\///"
fi

rm -rf ${TEMPDIR} &> /dev/null

# exit 1
exit $resulting_status
```
