module Accounting
  require_dependency 'accounting/base/invoice'
  require_dependency 'accounting/economic/invoice'
  require_dependency 'accounting/tripletex/invoice'
  require_dependency 'accounting/base/product'
  require_dependency 'accounting/economic/product'
  require_dependency 'accounting/tripletex/product'
  
  class OperationError < StandardError
  end
end
