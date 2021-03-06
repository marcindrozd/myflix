require 'paratrooper'

namespace :deploy do
 desc 'Deploy app in staging environment'
 task :staging do
   deployment = Paratrooper::Deploy.new("md-myflix-staging", tag: 'staging-env')

   deployment.deploy
 end

 desc 'Deploy app in production environment'
 task :production do
   deployment = Paratrooper::Deploy.new("md-myflix") do |deploy|
     deploy.tag              = 'production',
     deploy.match_tag        = 'staging-env'
   end

   deployment.deploy
 end
end
