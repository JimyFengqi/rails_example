class User < ApplicationRecord
  attr_accessor :remember_token

  before_save {email.downcase!}   #保存密码前，检查邮件地址存在而且自动转换为消协字母
  validates(:name,presence:true,length:{maximum:50})  #验证名字存在而且最长为50个字符
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:true, length:{maximum:240},
		format: {with: VALID_EMAIL_REGEX},
		uniqueness: { case_sensitive: false }				#email存在最长为240个字符，邮件地址符合规则，具有大小写敏感唯一性
  validates :password,presence: true, length: { minimum: 6},allow_nil:true

  has_secure_password	
  class << self
  # 返回指定字符串的哈希摘要
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end	

    def new_token
  	  SecureRandom.urlsafe_base64
    end
  end

  # 为了持久保存会话，在数据库中记住用户
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
  	return false if remember_digest.nil?
  	BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
  	update_attribute(:remember_digest,nil)
  end
  

end
