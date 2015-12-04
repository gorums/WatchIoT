class SpaceCanEditValidator < ActiveModel::Validator

  ##
  # I can create space on my account or if i belong to team and i
  # have permission to create_space
  #
  def validate(record)
    if record.user_id != record.user_owner_id &&
        !TeamSpace.has_permission?(record.user_id, record.user_owner_id, 'edit_space')
      record.errors[:base] << 'You cant edit a space'
    end
  end

end