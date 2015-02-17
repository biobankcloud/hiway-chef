# download bowtie2 binaries
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:bowtie2][:zip]}" do
  source node[:hiway][:variantcall][:bowtie2][:url]
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# install bowtie2
bash "install_bowtie2" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    unzip #{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:bowtie2][:zip]} -d #{node[:hiway][:software][:dir]}
  EOH
  not_if { ::File.exist?("#{node[:hiway][:variantcall][:bowtie2][:home]}") }
end

# add bowtie2 executables to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:hiway][:variantcall][:bowtie2][:home]}/bowtie2* /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/bowtie2") }
end

# download bwa sources
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:bwa][:tarbz2]}" do
  source node[:hiway][:variantcall][:bwa][:url]
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# compile and install bwa
bash "install_bwa" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xjvf #{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:bwa][:tarbz2]} -C #{node[:hiway][:software][:dir]}
    make -C #{node[:hiway][:variantcall][:bwa][:home]}
  EOH
  not_if { ::File.exist?("#{node[:hiway][:variantcall][:bwa][:home]}") }
end

# add bwa executable to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:hiway][:variantcall][:bwa][:home]}/bwa /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/bwa") }
end

# install libcurses, which is required for building samtools
case node[:platform_family]
  when "debian"
    package "libncurses5-dev" do
      options "--force-yes"
    end
end

# download samtools sources
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:samtools][:tarbz2]}" do
  source node[:hiway][:variantcall][:samtools][:url]
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# compile and install samtools
bash "install_samtools" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xjvf #{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:samtools][:tarbz2]} -C #{node[:hiway][:software][:dir]}
    make -C #{node[:hiway][:variantcall][:samtools][:home]}
  EOH
  not_if { ::File.exist?("#{node[:hiway][:variantcall][:samtools][:home]}") }
end

# add samtools executable to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:hiway][:variantcall][:samtools][:home]}/samtools /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/samtools") }
end

# create varscan directory
directory node[:hiway][:variantcall][:varscan][:home] do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
  recursive true
end

# download varscan jar
remote_file "#{node[:hiway][:variantcall][:varscan][:home]}/#{node[:hiway][:variantcall][:varscan][:jar]}" do
  source node[:hiway][:variantcall][:varscan][:url]
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# add script for running varscan
template "#{node[:hiway][:variantcall][:varscan][:home]}/varscan" do 
  source "varscan.erb"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# add varscan executable to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:hiway][:variantcall][:varscan][:home]}/varscan /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/varscan") }
end

# download annovar binaries
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:annovar][:targz]}" do
  source node[:hiway][:variantcall][:annovar][:url]
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# install annovar
bash "install_annovar" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xvfz #{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:annovar][:targz]} -C #{node[:hiway][:software][:dir]}
  EOH
  not_if { ::File.exist?("#{node[:hiway][:variantcall][:annovar][:home]}") }
end

# add annovar executables to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:hiway][:variantcall][:annovar][:home]}/*.pl /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/annotate_variation.pl") }
end

# prepare the variant call workflow file
template "#{node[:hiway][:cuneiform][:home]}/#{node[:hiway][:variantcall][:hg38][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:variantcall][:hg38][:workflow]}.erb"
  mode "755"
end

# create reads directory
directory node[:hiway][:variantcall][:hg38][:reads][:directory] do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
  recursive true
end

# create reference directory
directory node[:hiway][:variantcall][:hg38][:reference][:directory] do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
  recursive true
end

# create annovar database directory
directory node[:hiway][:variantcall][:hg38][:annovardb][:directory] do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
  recursive true
end

# obtain workflow input data
bash 'download_input_data' do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e
    wget -q -O - "#{node[:hiway][:variantcall][:hg38][:reads][:url]}/#{node[:hiway][:variantcall][:hg38][:reads][:gz1]}" | gzip -cd | head -n #{node[:hiway][:variantcall][:hg38][:reads][:lines]} > #{node[:hiway][:cuneiform][:home]}/#{node[:hiway][:variantcall][:hg38][:reads][:directory]}/#{node[:hiway][:variantcall][:hg38][:reads][:file1]}
    wget -q -O - "#{node[:hiway][:variantcall][:hg38][:reads][:url]}/#{node[:hiway][:variantcall][:hg38][:reads][:gz2]}" | gzip -cd | head -n #{node[:hiway][:variantcall][:hg38][:reads][:lines]} > #{node[:hiway][:cuneiform][:home]}/#{node[:hiway][:variantcall][:hg38][:reads][:directory]}/#{node[:hiway][:variantcall][:hg38][:reads][:file2]}
    wget -q -O - "#{node[:hiway][:variantcall][:hg38][:reference][:url]}/#{node[:hiway][:variantcall][:hg38][:reference][:gz1]}" | gzip -cd > #{node[:hiway][:cuneiform][:home]}/#{node[:hiway][:variantcall][:hg38][:reference][:directory]}/#{node[:hiway][:variantcall][:hg38][:reference][:file1]}
    wget -q -O - "#{node[:hiway][:variantcall][:hg38][:reference][:url]}/#{node[:hiway][:variantcall][:hg38][:reference][:gz2]}" | gzip -cd > #{node[:hiway][:cuneiform][:home]}/#{node[:hiway][:variantcall][:hg38][:reference][:directory]}/#{node[:hiway][:variantcall][:hg38][:reference][:file2]}
    annotate_variation.pl -downdb -webfrom annovar refGene -buildver hg38 "#{node[:hiway][:cuneiform][:home]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:directory]}/db/"
    tar cf "#{node[:hiway][:cuneiform][:home]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:directory]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:file]}" -C "#{node[:hiway][:cuneiform][:home]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:directory]}" db
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:cuneiform][:home]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:directory]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:file]}" ) }
end
