#!/usr/bin/env bash

# manually install this one report dependency. Avoid installing all deps.
rm package.json
npm i details-element-polyfill@2.2.0

mkdir -p dist

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
