
# Create network infrastructure
module "network" {
    source = "./modules/network"
    org_code = var.org_code
    vpc_cidr = var.vpc_cidr
    layer-subnets-num = var.layer-subnets-num
}

# Create security configurations
module "security" {
    source = "./modules/security"
    org_code = var.org_code
    vpc_id = module.network.network-vpc.id
    org_base_domain = var.org_base_domain
    assume_role_name = var.assume_role_name
    assume_role_service = var.assume_role_service
    iam_role_policy_action = var.iam_role_policy_action
    wpsite_a_record = var.wpsite_a_record
    toolingsite_a_record = var.toolingsite_a_record
    bastion_cidr = var.bastion_cidr
    alias_name = module.load_balancers.public_alb.dns_name
    alias_zone_id = module.load_balancers.public_alb.dns_name
    tags = var.tags
} 

# Create load balancers
module "load_balancers" {
    source = "./modules/alb"
    public_alb_security_groups = [module.security.public_alb_sg.id]
    internal_alb_security_groups = [module.security.internal_alb_sg.id]
    public_alb_subnets = [module.network.public_subnets[0].id, module.network.public_subnets[1].id]
    internal_alb_subnets = [module.network.compute_subnets[0].id, module.network.compute_subnets[1].id]
    org_code = var.org_code
    vpc_id = module.network.network-vpc.id
    org_base_domain = var.org_base_domain
    tags = var.tags
}

# Set up Autoscaling & Launch Templates
module "asg_compute" {
    source = "./modules/autoscaling"
    iam_instance_profile_id = module.security.instance_profile.id
    keypair = var.keypair
    az_list_names = module.network.az_list_names
    tags = var.tags

    bastion_instance_type = var.bastion_instance_type
    bastion_security_grp_ids = [module.security.bastion_sg.id]
    bastion_vpc_zone_id = [module.network.public_subnets[0].id, module.network.public_subnets[1].id]
    
    nginx_proxy_instance_type = var.nginx_proxy_instance_type
    nginx_proxy_security_grp_ids = [module.security.nginx_sg.id]
    nginx_proxy_vpc_zone_id = [module.network.proxy_subnets[0].id, module.network.proxy_subnets[1].id]
    
    wpsite_instance_type = var.wpsite_instance_type
    wpsite_target_grp_arn = module.load_balancers.wpsite_lb_target_grp.arn
    wpsite_security_grp_ids = [module.security.webserver_sg.id]
    wpsite_vpc_zone_id = [module.network.compute_subnets[0].id, module.network.compute_subnets[1].id]

    tooling_instance_type = var.tooling_instance_type
    tooling_target_grp_arn = module.load_balancers.tooling_lb_target_grp.arn
    tooling_security_grp_ids = [module.security.webserver_sg.id]
    tooling_vpc_zone_id = [module.network.compute_subnets[0].id, module.network.compute_subnets[1].id]
}

# Set up EFS
module "efs" {
    source = "./modules/efs"
    org_code = var.org_code
    aws_account_no = var.aws_account_no
    aws_account_user = var.aws_account_user
    layer-subnets-num = var.layer-subnets-num
    subnet_layer = module.network.compute_subnets
    security_group_ids = [module.security.data_layer_sg.id]
    wpsite_root_directory = var.wpsite_root_path
    tooling_root_directory = var.tooling_root_path
    az_list_names = module.network.az_list_names
    tags = var.tags
}

# Set up RDS
module "rds" {
    source = "./modules/rds"
    org_code = var.org_code
    subnet_ids_list = [module.network.data_subnets[0].id, module.network.data_subnets[1].id]
    db_instance_type = var.db_instance_type
    rds_db_name = var.rds_db_name
    rds_dbadmin_password = var.rds_dbadmin_password
    rds_dbadmin_username = var.rds_dbadmin_username
    security_groups_ids = [module.security.data_layer_sg.id]
    tags = var.tags
}