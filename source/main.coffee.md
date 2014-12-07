Sheet
=====

Spreadsheets of the future. From the past.

    Sheet = require "./sheet"
    sheet = Sheet()

    table = require "./templates/table"
    sidebar = require "./templates/sidebar"

    document.body.appendChild sidebar()
    document.body.appendChild table(sheet)
