class Application.DistributionAppView extends Application.TransactionAppView
  initialize: (transaction, save_url)->
    DistributionAppView.__super__.initialize(transaction, save_url)
    new Application.LimitCategoriesView(collection : @transaction.transaction_items)
