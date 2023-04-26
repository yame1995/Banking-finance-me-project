resource "aws_instance" "test-server" {
  ami           = "ami-02396cdd13e9a1257" 
  instance_type = "t2.micro" 
  key_name = "newkey"
  vpc_security_group_ids= ["sg-06fad7f272e56cbbf"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    #private_key = file("./newkey.pem")
    private_key = file("newkey.pem")
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
  command = "ansible-playbook /var/lib/jenkins/workspace/finance project/my-serverfiles/finance-playbook.yml "
  } 
}
