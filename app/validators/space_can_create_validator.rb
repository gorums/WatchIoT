class SpaceCanCreateValidator < ActiveModel::Validator

  ##
  # I can create space on my account or if i belong to team and i
  # have permission
  #
  def validate(record)
    if record.user_id != record.user_owner_id

    end
    record.errors[:base] << "This person is evil"
  end

end