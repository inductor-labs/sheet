Editor
======

    {defaults} = require "./util"
    Model = require "./model"
    Dataset = require "./dataset"

    FromFile = require "./file_reader"

    DATA_NAME = "sheet:APP_DATA"

    module.exports = (I={}, self=Model(I)) ->
      defaults I,
        datasets: [{}]
        activeDatasetIndex: 0

      self.attrModels "datasets", Dataset
      self.attrObservable "activeDatasetIndex"

      # Proxy a bunch of stuff
      self.extend
        activeDataset: ->
          self.datasets.get(self.activeDatasetIndex())

        activeStep: ->
          self.activeDataset().activeStep()

        inputData: ->
          self.activeDataset().inputData()

        outputData: ->
          self.activeDataset().outputData()

        saveData: ->
          localStorage[DATA_NAME] = JSON.stringify(self.toJSON())

        fromLocalStorage: ->
          self.loadData JSON.parse(localStorage[DATA_NAME])

        loadData: (data) ->
          self.datasets data.datasets.map (dataset) ->
            Dataset dataset

        fileInput: ->
          FromFile.readerInput
            json: self.loadData
            text: (content) ->
              self.loadData self.loadCSVFromText(content)

      return self
