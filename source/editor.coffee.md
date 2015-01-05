Editor
======

    Dataset = require "./dataset"
    Model = require "./model"
    Observable = require "o_0"
    {defaults} = require "./util"

    DATA_NAME = "sheet:APP_DATA"

    module.exports = (I={}, self=Model(I)) ->
      defaults I,
        datasets: [{}]
        activeDatasetIndex: 0

      self.attrModels "datasets", Dataset
      self.attrObservable "activeDatasetIndex"

      self.extend
        activeStep: ->
          self.activeDataset().activeStep()

        newDataset: ->
          dataset = Dataset()

          self.datasets.push dataset
          self.activeDataset dataset

          return dataset

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

          self.activeDatasetIndex(data.activeDatasetIndex ? 0)

      # This is providing a bi-directional binding from activeDataset to activeDatasetIndex
      # We should figure out how to extract this into a common pattern.
      do ->
        update = (index) ->
          self.activeDataset self.datasets.get(index)

        self.activeDataset = Observable()
        self.activeDatasetIndex.observe update

        update(self.activeDatasetIndex())

        self.activeDataset.observe (dataset) ->
          self.activeDatasetIndex self.datasets.indexOf dataset

      return self
