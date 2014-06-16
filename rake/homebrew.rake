
require_relative "lib/output"
require_relative "lib/homebrew"
require_relative "lib/sh"

desc "Ensure homebrew is installed and up to date"
task :homebrew => 'homebrew:update'

verbose(false)

namespace :homebrew do

    task :install do
        unless Homebrew.is_installed?
            echo "Installing Homebrew..."
            Homebrew.bootstrap
        end

        Homebrew.tap('homebrew/dupes')
        Homebrew.tap('phinze/cask')

        %w{
            coreutils
            wget
            curl
            tree
            git
            brew-cask
            the_silver_searcher
            tmux
            gist
            lua
            luajit
        }.each { |pkg| Homebrew.install pkg }

        %w{
            dropbox
            appcleaner
            vagrant
            virtualbox
            growlnotify
            iterm2
            java
        }.each { |app| Homebrew.install_cask app }

        echo "Homebrew is installed. Moving on."
    end

    task :update => :install do
        echo "Updating homebrew..."
        Homebrew.update
    end

    desc "Remove homebrew cleanly"
    task :remove do
        Homebrew.destroy if Homebrew.is_installed?
    end

end

