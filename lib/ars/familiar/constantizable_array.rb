class ConstantizableArray < Array
  ConstantizableArray::EMPTY_PARAM = "EMPTY_PARM".freeze
  def constantize(wedge = EMPTY_PARAM)
    wedge == EMPTY_PARAM && wedge = '::'
    self.compact.join(wedge).constantize
  end
end
