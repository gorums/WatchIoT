##
# I can create space on my account or if i belong to team and i
# have permission to create_space
#
class SpaceCanCreateValidator < ActiveModel::Validator

  ##
  # Validate
  #
  def validate(record)
    if record.user_id != record.user_owner_id &&
        !Team.permission?(record.user_id, record.user_owner_id, 'create_space')
      record.errors[:base] << 'You cant create a space'
    end
  end

end
