# atlassian-rest-api
make sure you have the following tools installed
- curl
- jq

# setup
rename .env_template to .env

edit .env and replace
- SOME-WRITABLE-DIRECTORY
- YOUR-SITE-NAME
- NUMERIC-JIRA-ADMIN-ID
- NUMERIC-CONFLUENCE-ADMIN-ID

rename .netrc-confluence-cloud_template to .netrc-confluence-cloud

edit .netrc-confluence-cloud and replace
- YOUR-SITE-NAME
- ADMIN-API-USER@YOUR-COMPANY.TLD
- YOUR-SECRET-PASSWORD

rename .netrc-jira-cloud_template to .netrc-jira-cloud

edit .netrc-jira-cloud and replace
- YOUR-SITE-NAME
- ADMIN-API-USER@YOUR-COMPANY.TLD
- YOUR-SECRET-PASSWORD

