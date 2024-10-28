locals {
  private_key_filename = "${var.path}/${var.key_name}.pem"
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  count    = var.path != "" ? 1 : 0
  content  = tls_private_key.key.private_key_pem
  filename = local.private_key_filename
}

resource "null_resource" "chmod" {
  count      = var.path != "" ? 1 : 0
  depends_on = [local_file.private_key_pem]

  triggers = {
    key = tls_private_key.key.private_key_pem
  }

  provisioner "local-exec" {
    command = "chmod 600 ${local.private_key_filename}"
  }
}

resource "aws_instance" "app-server1" {
  count = length(var.public_subnets_cidr)
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.amazon_ami.id
  vpc_security_group_ids = [aws_security_group.http-sg.id]
  subnet_id              = aws_subnet.public-1a.*.id[count.index]
  key_name               = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true
  root_block_device {
    volume_type = "gp3"
    volume_size = "30"
    tags = {
      Name = "app-server-1"
    }
  }
  #ebs_block_device{
  #  device_name = "/dev/sdf"
  #  volume_size = 125
  #  volume_type = "st1"
  #}
  #  tags = {
  #    Name = "app-server-1"
  #  }


  connection {
        host = self.public_ip
      }

  provisioner "local-exec" {
    command = <<EOT
         sleep 50;
             >application.ini;
            echo "[Default]" | tee -a application.ini;
            echo "${self.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${local.private_key_filename}" | tee -a application.ini;
      export ANSIBLE_HOST_KEY_CHECKING=False;
           ansible-playbook --user ${var.ansible_user} --private-key ${local.private_key_filename} -i application.ini ansible-apache/httpd.yaml
    EOT
  }

}