# run the word count workflow on hiway
bash "run_wordcount" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    hiway -w "#{node[:hiway][:home]}/#{node[:hiway][:wordcount][:workflow]}" -s "#{node[:hiway][:home]}/wordcount_summary.json"
    #{node[:hadoop][:home]}/bin/hdfs dfs -get `grep -oP '\"output\":\[\"\K[^\"]+' "#{node[:hiway][:home]}/wordcount_summary.json"`
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:home]}/wordcount_summary.json" ) }
end
