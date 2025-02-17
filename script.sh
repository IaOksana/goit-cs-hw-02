#!/bin/bash
echo "Hi"
log_file="website_status.log"
websites=("https://github.com" "https://google.com" "https://facebook.com" "https://twitter.com")

for j in "${websites[@]}"; do
  res=$(curl -s -o /dev/nul -w "%{http_code}" $j)
  if [ $res -eq 200 ]
  then echo "Index: $j, status: $res - is UP" | tee -a "$log_file"
  elif [ $res -eq 301 ] || [ $res -eq 302 ]
  then
  redirected_url=$(curl -Ls -o /dev/nul -w "%{url_effective}" $j)
  echo "Index: $j, status: $res - is REDIRECTED to $redirected_url" | tee -a "$log_file"
  else
  echo "Index: $j, status: $res  - is DOWN" | tee -a "$log_file"
  fi
done
echo "All the results are in $log_file "