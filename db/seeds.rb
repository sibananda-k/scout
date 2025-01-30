Role.create!(["Owner", "Admin", "Full Member", "Limited Full Member","ReadOnly"].map { |role_name| { name: role_name } })
