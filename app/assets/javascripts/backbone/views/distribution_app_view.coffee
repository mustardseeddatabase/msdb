class Application.DistributionAppView extends Application.TransactionAppView
  initialize: (transaction, save_url)->
    save_method = "no-ajax"
    DistributionAppView.__super__.initialize(transaction, save_url, save_method)
    new Application.LimitCategoriesView(collection : @transaction.transaction_items)
