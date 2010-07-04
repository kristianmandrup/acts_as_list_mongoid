module DefaultBehavior
  attr_accessor :before_save_triggered

  def log_before_save
    self.before_save_triggered = true
  end
end
