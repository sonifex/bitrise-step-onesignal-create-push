#!/bin/bash
set -ex

if [ -z "${onesignal_rest_api_key}" ]; then
	echo '* Required input `$onesignal_rest_api_key` not provided!'
	exit 1
fi

if [ -z "${onesignal_app_id}" ]; then
	echo '* Required input `$onesignal_app_id` not provided!'
	exit 1
fi

if [ -z "${push_title}" ]; then
	echo '* Required input `$push_title` not provided!'
	exit 1
fi

if [ -z "${push_body}" ]; then
	echo '* Required input `$push_body` not provided!'
	exit 1
fi

onesignalRestApiKey="${onesignal_rest_api_key}"
onesignalAppID="${onesignal_app_id}"
pushTitle="${push_title}"
pushBody="${push_body}"
installPageUrl="${app_public_install_page}"


echo
echo "===OneSignal Config==="
echo "* OneSignal Rest Api Key: ${onesignalRestApiKey}"
echo "* OneSignal App Id: ${onesignalAppID}"
echo "* Push Title: ${pushTitle}"
echo "* Push Body: ${pushBody}"
echo "* Public Install Page: ${installPageUrl}"
echo


JSON='{"app_id": "'${onesignalAppID}'",
"headings": {"en": "'${pushTitle}'"},
"contents": {"en": "'${pushBody}'"},
"url": "'${installPageUrl}'",
"included_segments": ["Test Users"]}'

eval
curl \
--include \
--request POST \
--header 'Content-Type: application/json; charset=utf-8' \
--header 'Authorization: Basic '${onesignalRestApiKey} \
--data-binary "${JSON}" https://onesignal.com/api/v1/notifications

curl_res=$?

if [ ${curl_res} -eq 0 ]; then
	echo "# Success"
else
	echo "# Error"
	echo "* cURL ping returned an error (${curl_res})"
	echo "* see the logs for more details" false
fi

exit ${curl_res}
