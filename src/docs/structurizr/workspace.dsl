workspace {

    model {
        user = person "User" "Endanwender"

        softwareSystem = softwareSystem "SoftwareSystem" {
            webapp = container "Web Application" "Java/Spring Boot"
            database = container "Database" "PostgreSQL"
            webapp -> database "Liest/Schreibt" "SQL/TCP"
        }

        user -> webapp "Nutzt" "HTTPS"

        deploymentEnvironment "Production" {
            deploymentNode "AWS" {
                tags "Amazon Web Services - Cloud"
                region = deploymentNode "eu-central-1" {
                    tags "Amazon Web Services - Region"

                    alb = infrastructureNode "Application Load Balancer" {
                        tags "Amazon Web Services - Application Load Balancer"
                    }

                    webSg = infrastructureNode "Web Security Group" {
                        tags "Amazon Web Services - VPC Security Group"
                    }
                    dbSg = infrastructureNode "Database Security Group" {
                        tags "Amazon Web Services - VPC Security Group"
                    }

                    asg = deploymentNode "Auto Scaling Group" {
                        azA = deploymentNode "Availability Zone A" {
                            tags "Amazon Web Services - Availability Zone"
                            deploymentNode "EC2 Instance" {
                                tags "Amazon Web Services - EC2"
                                webappInst1 = containerInstance webapp
                            }
                        }
                        azB = deploymentNode "Availability Zone B" {
                            tags "Amazon Web Services - Availability Zone"
                            deploymentNode "EC2 Instance" {
                                tags "Amazon Web Services - EC2"
                                webappInst2 = containerInstance webapp
                            }
                        }
                        azC = deploymentNode "Availability Zone C" {
                            tags "Amazon Web Services - Availability Zone"
                            deploymentNode "EC2 Instance" {
                                tags "Amazon Web Services - EC2"
                                webappInst3 = containerInstance webapp
                            }
                        }
                    }

                    deploymentNode "RDS Multi-AZ" {
                        tags "Amazon Web Services - RDS"
                        dbInst = containerInstance database
                    }

                    alb -> webappInst1 "Forwarded"
                    alb -> webappInst2 "Forwarded"
                    alb -> webappInst3 "Forwarded"
                    webSg -> alb "Sichert"
                    dbSg -> dbInst "Sichert"
                }
            }
        }
    }

    views {
        # --- DIESE BLÖCKE FEHLTEN ---

        # 1. System Context View
        systemContext softwareSystem "SystemContext-001" {
            include *
            autolayout lr
        }

        # 2. Container View
        container softwareSystem "Containers-001" {
            include *
            autolayout lr
        }

        # 3. Deine HA Deployment View
        deployment softwareSystem "Production" "AWS_HA_Sicht" {
            include *
            autolayout lr
        }

        theme https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json

        styles {
            element "Infrastructure Node" {
                shape RoundedBox
            }
        }
    }
}