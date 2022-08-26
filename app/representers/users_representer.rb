class UsersRepresenter
  def initialize(user)
    @user = user
  end

  def as_json
    ret = []
    user.each do |user|
      inv = {
        id: user.id,
        username: user.username
      }
      ret.push(inv)
    end
    ret
  end

  private

  attr_reader :user
end
