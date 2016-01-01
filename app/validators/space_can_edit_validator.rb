##
# I can create space on my account or if i belong to team and i
# have permission to create_space
#
class SpaceCanEditValidator < ActiveModel::Validator
  ##
  # Validator
  #
  def validate(record)
    if record.user_id != record.user_owner_id &&
        !TeamSpace.permission?(record.user_id, record.user_owner_id, 'edit_space')
      record.errors[:base] << 'You cant edit a space'
    end
  end
end
