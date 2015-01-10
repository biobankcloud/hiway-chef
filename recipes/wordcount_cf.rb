template "#{node[:hiway][:home]}/#{node[:hiway][:wordcount][:workflow]}" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  source "#{node[:hiway][:wordcount][:workflow]}.erb"
  mode "0774"
end

template "#{node[:hiway][:home]}/benzko.txt" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  source "wordcount.benzko.txt.erb"
  mode "0774"
end

template "#{node[:hiway][:home]}/gronemeyer.txt" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  source "wordcount.gronemeyer.txt.erb"
  mode "0774"
end

bash "prepare_wordcount" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  code <<-EOF
  set -e && set -o pipefail
  . #{node[:hadoop][:home]}/sbin/set-env.sh
  #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/benzko.txt
  #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/gronemeyer.txt
  EOF
  only_if { ". #{node[:hadoop][:home]}/sbin/set-env.sh && #{node[:hadoop][:home]}/bin/hdfs dfs -test -e /user/#{node[:hiway][:user]}/benzko.txt" && "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e /user/#{node[:hiway][:user]}/gronemeyer.txt"}
end

bash "run_wordcount" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  code <<-EOF
  set -e && set -o pipefail
  . #{node[:hadoop][:home]}/sbin/set-env.sh
  for i in {1..#{node[:hiway][:wordcount][:iterations]}}
  do
#    #{node[:hadoop][:home]}/bin/yarn jar #{node[:hiway][:home]}/hiway-core-#{node[:hiway][:version]}.jar -w #{node[:hiway][:home]}/#{node[:hiway][:wordcount][:workflow]} -s #{node[:hiway][:home]}/wordcount_summary_$i.json
  done
  EOF
#    not_if { ::File.exists?("#{node[:hiway][:home]}/wordcount_summary.json") }
end
