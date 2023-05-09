resource "aws_instance" "test-server" {
  ami           = "ami-0b08bfc6ff7069aff" 
  instance_type = "t2.micro" 
  key_name = "yamuna"
  vpc_security_group_ids= ["sg-0d79d8cacae87b89e"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    #private_key = file("./yamuna.pem")
    private_key = file("yamuna.pem")
    timeout = "3m"
    agent = false
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
  }
   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/financeme-project/my-serverfiles/finance-playbook.yml "
  } 
}
