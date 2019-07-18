class User < ApplicationRecord
  attr_accessor :remember_token,:activation_token,:reset_token
  before_save   :downcase_email  #保存密码前，检查邮件地址存在而且自动转换为小写字母
  before_create :create_activation_digest

  
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

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
  	update_attribute(:remember_digest,nil)
  end
  def activate 
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # 设置密码重设相关的属性
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
    # 发送密码重设邮件
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # 如果密码重设请求超时了，返回 true
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  private
    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest   = User.digest(activation_token)
    end

end
