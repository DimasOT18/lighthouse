#!/usr/bin/env bash
set -x

# manually install this one report dependency. Avoid installing all deps.
rm package.json
npm i details-element-polyfill@2.2.0

mkdir -p dist

# Ideally we early exit if no report stuff was affected. However deployments would still be made. They'd just fail or w/e.
# we'd have to use NOW_GITHUB_COMMIT_SHA to find the PR to use
#     https://zeit.co/docs/v2/integrations/now-for-github/#included-environment-variables

# CHANGED_FILES=$(curl https://api.github.com/repos/GoogleChrome/lighthouse/pulls/8158 -H "Accept: application/vnd.github.v3.patch" | tr '\n' '$' | sed 's/diff --git.*//; s/.*---//;') # oddly couldnt get patch output to work on commits, though that's moot
# if ! echo $CHANGED_FILES | grep -E 'report|audits|i18n' > /dev/null; then
#   echo "No report files affected, skipping report generation."
#   exit 0
# fi

# generate the report and place as dist/index.html
node -e "
   console.log('🕒 Generating report for sample_v2.json...');
   const ReportGenerator = require('./lighthouse-core/report/report-generator');
   const lhr = require('./lighthouse-core/test/results/sample_v2.json');

   const html = ReportGenerator.generateReportHtml(lhr);
   const filename = './dist/index.html';
   fs.writeFileSync(filename, html, {encoding: 'utf-8'});
   console.log('✅', filename, 'written.')
"
