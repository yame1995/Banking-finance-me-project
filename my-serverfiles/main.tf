resource "aws_instance" "test-server" {
  ami           = "ami-0c768662cc797cd75" 
  instance_type = "t2.micro" 
  key_name = "newkey"
  vpc_security_group_ids= ["sg-0315c97a013200234"]
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
  command = "ansible-playbook /var/lib/jenkins/workspace/finance-project01/my-serverfiles/finance-playbook.yml "
  } 
}
