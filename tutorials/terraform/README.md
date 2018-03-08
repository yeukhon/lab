## Terraform

Some example code either taken straight from official
Terraform docs or my own learning materials.

### Commands

``terraform init``

    According to the doc, this will download all appropriate provider
    binaries needed to execute resources (e.g. aws_resource) since each
    provider binary is now distributed standlone (probably to reduce
    ``terraform``'s size).

``terraform plan``

    Call this to review changes.

``terraform apply``

    Execute the change.

### Destroy resource

To remove a resource managed by Terraform, you can either

1. remove the relevant resource code from ``*.tf`` file and
run``terraform plan`` and ``terraform apply``; or

2. run ``terraform destroy -target RESOURCE_TYPE.RESOURCE_NAME``

For example, to remove ``allow_ssh_22`` security group from
``aws.tf``, we run
``terraform destroy -target aws_security_group.allow_ssh_22``.

``destroy`` command allows multiple ``-target``.

### Remove resource from state

To remove a resource from Terraform's state, run

``terraform state rm RESOURCE_TYPE.RESOURCE_NAME``

For example, to remove ``allow_ssh_22`` security group
from the *state*, we run
``terraform state rm aws_security_group.allow_ssh_22``.

### Example

In this example, we will create an EC2 instance with a security
group to allow SSH access, and teardown the resources using terraform.

In ``aws.tf``, we have two resources:

* t2_terraform_starter: a t2.micro Ubuntu EC2 instance

* allow_ssh_22: a security group that allows SSH access

### Create resources

Run ``terraform plan`` to review changes.

```
Johns-MBP:terraform yeukhon$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + aws_instance.t2_terraform_starter
      id:                                    <computed>
      ami:                                   "ami-965e6bf3"
      associate_public_ip_address:           <computed>
      availability_zone:                     <computed>
      ebs_block_device.#:                    <computed>
      ephemeral_block_device.#:              <computed>
      instance_state:                        <computed>
      instance_type:                         "t2.micro"
      ipv6_address_count:                    <computed>
      ipv6_addresses.#:                      <computed>
      key_name:                              "aws-yeukhon-ec2"
      network_interface.#:                   <computed>
      network_interface_id:                  <computed>
      placement_group:                       <computed>
      primary_network_interface_id:          <computed>
      private_dns:                           <computed>
      private_ip:                            <computed>
      public_dns:                            <computed>
      public_ip:                             <computed>
      root_block_device.#:                   <computed>
      security_groups.#:                     <computed>
      source_dest_check:                     "true"
      subnet_id:                             "subnet-b30fb9db"
      tags.%:                                "1"
      tags.Name:                             "t2_terraform_starter"
      tenancy:                               <computed>
      volume_tags.%:                         <computed>
      vpc_security_group_ids.#:              "1"
      vpc_security_group_ids.4206251436:     "sg-10e2567b"

  + aws_security_group.allow_ssh_22
      id:                                    <computed>
      description:                           "Allow SSH"
      egress.#:                              <computed>
      ingress.#:                             "1"
      ingress.2541437006.cidr_blocks.#:      "1"
      ingress.2541437006.cidr_blocks.0:      "0.0.0.0/0"
      ingress.2541437006.description:        ""
      ingress.2541437006.from_port:          "22"
      ingress.2541437006.ipv6_cidr_blocks.#: "0"
      ingress.2541437006.protocol:           "tcp"
      ingress.2541437006.security_groups.#:  "0"
      ingress.2541437006.self:               "false"
      ingress.2541437006.to_port:            "22"
      name:                                  "allow_ssh_22"
      owner_id:                              <computed>
      revoke_rules_on_delete:                "false"
      vpc_id:                                "vpc-2aeb5f42"


Plan: 2 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

Looks good. We have two ``+`` which indicate Terraform is expecting to
create two resources: a security group and an EC2 instance with the
newly created security group attached.

Cool, so let's run ``terraform apply``. In a second, Terraform will
prompt us to confirm that we indeed want to execute the change. So, enter
``yes`` on the terminal.

```
....

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

```

Then Terraform will create the resources for you! EC2 can take
a while to create, so be patient (another reason I pick Ohio
is Ohio has fewer customers, so in theory should be "quicker"
to allocate. Just a theory).

```
aws_security_group.allow_ssh_22: Creating...
  description:                           "" => "Allow SSH"
  egress.#:                              "" => "<computed>"
  ingress.#:                             "" => "1"
  ingress.2541437006.cidr_blocks.#:      "" => "1"
  ingress.2541437006.cidr_blocks.0:      "" => "0.0.0.0/0"
  ingress.2541437006.description:        "" => ""
  ingress.2541437006.from_port:          "" => "22"
  ingress.2541437006.ipv6_cidr_blocks.#: "" => "0"
  ingress.2541437006.protocol:           "" => "tcp"
  ingress.2541437006.security_groups.#:  "" => "0"
  ingress.2541437006.self:               "" => "false"
  ingress.2541437006.to_port:            "" => "22"
  name:                                  "" => "allow_ssh_22"
  owner_id:                              "" => "<computed>"
  revoke_rules_on_delete:                "" => "false"
  vpc_id:                                "" => "vpc-2aeb5f42"
aws_instance.t2_terraform_starter: Creating...
  ami:                               "" => "ami-965e6bf3"
  associate_public_ip_address:       "" => "<computed>"
  availability_zone:                 "" => "<computed>"
  ebs_block_device.#:                "" => "<computed>"
  ephemeral_block_device.#:          "" => "<computed>"
  instance_state:                    "" => "<computed>"
  instance_type:                     "" => "t2.micro"
  ipv6_address_count:                "" => "<computed>"
  ipv6_addresses.#:                  "" => "<computed>"
  key_name:                          "" => "aws-yeukhon-ec2"
  network_interface.#:               "" => "<computed>"
  network_interface_id:              "" => "<computed>"
  placement_group:                   "" => "<computed>"
  primary_network_interface_id:      "" => "<computed>"
  private_dns:                       "" => "<computed>"
  private_ip:                        "" => "<computed>"
  public_dns:                        "" => "<computed>"
  public_ip:                         "" => "<computed>"
  root_block_device.#:               "" => "<computed>"
  security_groups.#:                 "" => "<computed>"
  source_dest_check:                 "" => "true"
  subnet_id:                         "" => "subnet-b30fb9db"
  tags.%:                            "" => "1"
  tags.Name:                         "" => "t2_terraform_starter"
  tenancy:                           "" => "<computed>"
  volume_tags.%:                     "" => "<computed>"
  vpc_security_group_ids.#:          "" => "1"
  vpc_security_group_ids.4206251436: "" => "sg-10e2567b"
aws_security_group.allow_ssh_22: Creation complete after 1s (ID: sg-a3dabbc8)
aws_instance.t2_terraform_starter: Still creating... (10s elapsed)
aws_instance.t2_terraform_starter: Still creating... (20s elapsed)
aws_instance.t2_terraform_starter: Creation complete after 22s (ID: i-097c1047a20668e09)

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

Great. Now you can verify by going to AWS console!

### Re-apply changes

Terraform is designed to be idempotent. So, without a change to ``aws.tf`` file,
Terraform will not make any changes.

Here is the output of ``terraform plan``:

```
...

No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.

```

Likewise, here is the output of ``terraform apply``:

```
aws_security_group.allow_ssh_22: Refreshing state... (ID: sg-a3dabbc8)
aws_instance.t2_terraform_starter: Refreshing state... (ID: i-097c1047a20668e09)

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

### Remove EC2

Money matter, so time to save some pennies and destroy our EC2 instance! One
method is to simply remove the relevant code from ``aws.tf``, and
re-run our ``review-then-change`` commands. Go ahead, and remove the this
whole block from ``aws.tf``:

```
resource "aws_instance" "t2_terraform_starter" {
  ...
}
```

Save the file, and look at the outputs of ``terraform plan`` and
``terraform apply``. After applying the change, your EC2
instance should be terminated.

Another method to remove the physical resource is with a command.
In our example, we just removed the EC2 instance, but we haven't
deleted our security group yet. The command to destroy is

```
terraform destroy -target aws_security_group.allow_ssh_22

```

This tells Terraform to look for a resource called
``allow_ssh_22`` whose resource type is ``aws_security_group``.

This command effectively acts like "terraform apply`` but without
needing to edit ``aws.tf``.

```
Johns-MBP:terraform yeukhon$ terraform destroy -target aws_security_group.allow_ssh_22
aws_security_group.allow_ssh_22: Refreshing state... (ID: sg-a3dabbc8)

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  - aws_security_group.allow_ssh_22


Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value:

...

Destroy complete! Resources: 1 destroyed.
```

If you run ``terraform plan`` again, Terraform will tell
you it will create the security group again. This behavior is exactly
what we want: not only the physical resource has been eliminated,
the state file has also been updated!


### Remove resource from a state

Terraform relies on Terraform's state file to identify
what Terraform needs to manage. Using our security
group example above: suppose you just created the security
group using Terraform, and then you somehow are able
to rollback the state file to the version just prior
to the security group creation. Now what happens?

Well, the security group is still physically present
in your AWS account, but Terraform has no knowledge
of it anymore. Terraform will not manage this
security group. So there are two problems:

(1) You now have a piece of infrastructure that is
disconnected from your "source code"
(remember the goal of Terraform is "infrastructure
as code), and

(2) in the case of security group: you cannot
create a security group with the same name
within the same VPC.

If you have been following this tutorial all along,
please make sure our security group ``allow_ssh_22``
is destroyed using Terraform.

1. Open ``aws.tf``, locate ``t2_terraform_starter``
block, either comment out or remove the entire block,
and save the file.

2. Run ``terraform plan``. Terraform should show
only the security group will be created.

3. Run ``terraform apply`` and wait for command
finishes.

4. Next, run this strange command:

```
terraform state rm aws_security_group.allow_ssh_22

```

This command will remove the resource ``allow_ssh_22``
from Terraform's state file, as if we manually
rollback to an older state without ``allow_ssh_22``
ever recorded by Terraform.

5. Now, re-run ``terraform apply``. After giving your consent,
Terraform fails to this message:

```
Error: Error applying plan:

1 error(s) occurred:

* aws_security_group.allow_ssh_22: 1 error(s) occurred:

* aws_security_group.allow_ssh_22: Error creating Security Group: InvalidGroup.Duplicate: The security group 'allow_ssh_22' already exists for VPC 'vpc-2aeb5f42'
	status code: 400, request id: e75cd887-478e-43ac-a54f-2c23226e9b70

Terraform does not automatically rollback in the face of errors.
Instead, your Terraform state file has been partially updated with
any resources that successfully completed. Please address the error
above and apply again to incrementally change your infrastructure.
```

As we expected, VPC security group name must be unique. How do we fix this?
The best way to handle this is to
There are a number of ways to fix the problem.

1. Delete the orphan security group manually, then repeat ``plan-and-apply``.

2. Specify the ID of the resource in its dependents. In the case of a security group,
suppose some EC2 instance is already using the secruity group, we can
write

```
vpc_security_group_ids = ["sg-ID"]

```

instead of interpolation, and comment out ``allow_ssh_22`` resource block.

But the best practice is to make sure state file is always committed
at the end of every ``apply`` (or any destructive changes
such as ``destroy``, and ``state rm``.
