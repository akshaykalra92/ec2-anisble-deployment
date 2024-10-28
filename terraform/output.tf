output "instance_app-server1_public_dns" {
  value = aws_instance.app-server1.*.public_dns
}

output "private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive =true
}
