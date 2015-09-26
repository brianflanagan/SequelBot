directories %w(.) \
 .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

guard :foreman, procfile: 'Procfile'