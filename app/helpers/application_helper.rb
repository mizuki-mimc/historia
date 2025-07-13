module ApplicationHelper
  def required_attribute?(object, attribute)
    model = object.class
    model.validators_on(attribute).any? { |v| v.is_a? ActiveModel::Validations::PresenceValidator }
  end
end
