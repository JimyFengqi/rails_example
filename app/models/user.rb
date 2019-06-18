class User < ApplicationRecord
	
	#before_save {self.email = email.downcase }

	before_save {email.downcase!}   #保存密码前，检查邮件地址存在而且自动转换为消协字母

    #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates(:name,presence:true,length:{maximum:50})  #验证名字存在而且最长为50个字符
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence:true, length:{maximum:240},
		format: {with: VALID_EMAIL_REGEX},
		uniqueness: { case_sensitive: false }				#email存在最长为240个字符，邮件地址符合规则，具有大小写敏感唯一性
	validates :password,presence: true, length: { minimum: 6}

	has_secure_password		

end
