# Overview

JSON array as default data source. One row for each item.

Headers are the name of the property.

Functions can transform the data. Each function transforms the data set into a new table.

## Map / Reduce

* Map function - UI for creating map function, taking an input (CoffeeScript function) and returning the transformed value.

* Reduce function - UI for creating multiple items and returning one (SUM, AVG, STD)

* Transform nested associated data into flatter representation. Transform one item into a array of zero or more items (eg. user with a list of orders: return only a flat list of orders).

* Sorting functions.

* Simple visualizations: Bar Chart, Line Chart.

## Steps to Minimum Viable Sheet

* Load arbitrary JSON and display as a table.
  - Input to data source json
  - Type in https://api.github.com/gists
  - Output raw data as a table

* Transform the data to select a particular value. Display as a list
  - Textarea for CoffeeScript transform
  - Apply to whatever is currently returned from the json data source
  - Context of a map transform function is the specific item in the array
  - @user as a shortcut for `json.map -> @user`

* Save transforms (mapping transforms, reduce transforms, sorting transforms).
  - Short term: store as Gists
  - Longer term: consider s3 CAS for data security / multi tenancy. Also have a bucket for
publicly accessible tranforms.

* Publish transformed data set
  - Options for publishing time series
