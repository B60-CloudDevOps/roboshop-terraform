resource "null_resource" "metrics_server" {
  depends_on = ["aws_eks_cluster.main", "aws_eks_node_group.node_group"]

  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region us-east-1 --name "${var.cluster_name}-${var.env}" 
      kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
EOT
  }
}

# We can also do the same using helm provider;