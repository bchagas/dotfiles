unless defined?(RUBY_ENGINE) && RUBY_ENGINE == "macruby"
  begin
    gems = %w(rubygems irb/completion ap)

    gems.each do |gem_name|
      begin
        require gem_name
      rescue LoadError
      end
    end

    if RUBY_VERSION < "1.9"
      require "ruby-debug"
    else
      require "ruby-debug19"
    end

    # Load some libraries
    require "active_support/all" unless defined?(ActiveSupport)
    require "date"
    require "time"

    IRB.conf[:SAVE_HISTORY] = 100
    IRB.conf[:HISTORY_FILE] = "#{ENV["HOME"]}/.irb_history"
    IRB.conf[:AUTO_INDENT]  = true
    IRB.conf[:EVAL_HISTORY] = 100
    IRB.conf[:USE_READLINE] = true

    # Load history
    if File.file?(IRB.conf[:HISTORY_FILE])
      lines = File.readlines(IRB.conf[:HISTORY_FILE]).collect do |line|
        line.gsub(/^p */, "").chomp
      end
      Readline::HISTORY.push(*lines)
    end

    # Save history
    at_exit do
      lines = Readline::HISTORY.to_a.uniq
      lines = lines.reject {|l| %w[c exit l nil irb].include?(l) }

      count = lines.count
      start = [count - IRB.conf[:SAVE_HISTORY], 0].max
      lines = lines[start, IRB.conf[:SAVE_HISTORY]]

      File.open(IRB.conf[:HISTORY_FILE], "w+") do |file|
        file.flock(File::LOCK_EX)
        file.puts(lines)
        file.flock(File::LOCK_UN)
      end
    end

    IRB::Irb.class_eval do
      def output_value
        if @context.inspect?
          ap(@context.last_value)
        else
          printf @context.return_format, @context.last_value
        end
      end
    end

    prompt = "\033[1;30m#{RUBY_VERSION}\033[0m"

    IRB.conf[:PROMPT][:CUSTOM] = {
      :PROMPT_C => "#{prompt} \033[0;33m?>\033[0m ",
      :RETURN   => "=> %s\n",
      :PROMPT_I => "#{prompt} \033[0;33m>>\033[0m ",
      :PROMPT_N => "#{prompt} \033[0;33m>>\033[0m ",
      :PROMPT_S => nil
    }
    IRB.conf[:PROMPT_MODE] = :CUSTOM

    if ENV["RAILS_ENV"] || defined?(Rails)
      IRB.conf[:IRB_RC] = Proc.new do
        # Replace ActiveRecord logger
        ActiveRecord::Base.logger = Logger.new(STDOUT)

        # Set up ActiveRecord shortcut
        ActiveRecord::Base.instance_eval { alias :[] :find }
      end

      # Set short environment name for prompt
      envs = { "development" => "dev", "production" => "prod" }

      if defined?(Rails)
        current_env = Rails.env
      else
        current_env = ENV["RAILS_ENV"]
      end

      env = envs[current_env] || current_env
      prompt = "\033[1;30m#{env.upcase}##{RUBY_VERSION}\033[0m"

      IRB.conf[:PROMPT][:RAILS] = {
        :PROMPT_C => "#{prompt} \033[0;33m?>\033[0m ",
        :RETURN   => "=> %s\n",
        :PROMPT_I => "#{prompt} \033[0;33m>>\033[0m ",
        :PROMPT_N => "#{prompt} \033[0;33m>>\033[0m ",
        :PROMPT_S => nil
      }
      IRB.conf[:PROMPT_MODE] = :RAILS

      at_exit do
        # Empty every single log
        Dir["log/**/*.log"].each do |file|
          system "> #{file}"
        end
      end
    end

    # Display methods added by user.
    def m(subject)
      (subject.methods - subject.class.superclass.instance_methods).sort
    end
  rescue Exception => e
    puts e.message
  end
end