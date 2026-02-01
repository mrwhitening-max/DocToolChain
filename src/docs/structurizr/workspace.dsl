workspace {

    model {
        user = person "User" "Ein Endanwender des Systems"

        softwareSystem = softwareSystem "Mein Software System" {
            webapp = container "Web Application" "Bietet die Benutzeroberfläche" "Java/Spring Boot"
            database = container "Database" "Speichert Daten" "PostgreSQL"

            webapp -> database "Liest von und schreibt auf" "SQL/TCP"
        }

        user -> webapp "Nutzt die Anwendung über" "HTTPS"
    }

    views {
        systemContext softwareSystem {
            include *
            autolayout lr
        }

        container softwareSystem {
            include *
            autolayout lr
        }

        deployment softwareSystem "Production" "AWS_HA_Sicht" {
            include *
            autolayout lr
            description "Hochverfügbare AWS Architektur über 3 Availability Zones."
        }

        theme default

        styles {
            element "Infrastructure Node" {
                background #ffffff
                color #000000
                shape RoundedBox
            }
        }
    }

    # --- Deployment Bereich ---
    deploymentEnvironment "Production" {

        deploymentNode "AWS" {
            tags "Amazon Web Services - Cloud"

            region = deploymentNode "eu-central-1" {

                # Security Groups als Infrastructure Nodes
                webSg = infrastructureNode "Web Security Group" "Erlaubt Port 443"
                dbSg = infrastructureNode "Database Security Group" "Erlaubt Port 5432 von Web SG"

                alb = infrastructureNode "Application Load Balancer" "Externer HTTPS Load Balancer"

                # AZ 1
                az1 = deploymentNode "Availability Zone A" {
                    ec2_1 = deploymentNode "EC2 Instance" "t3.medium" {
                        webappInstance1 = containerInstance webapp
                    }
                }

                # AZ 2
                az2 = deploymentNode "Availability Zone B" {
                    ec2_2 = deploymentNode "EC2 Instance" "t3.medium" {
                        webappInstance2 = containerInstance webapp
                    }
                }

                # AZ 3
                az3 = deploymentNode "Availability Zone C" {
                    ec2_3 = deploymentNode "EC2 Instance" "t3.medium" {
                        webappInstance3 = containerInstance webapp
                    }
                }

                # Datenbank (RDS Multi-AZ)
                rds = deploymentNode "AWS RDS" "Managed Database Service" {
                    dbInstance = containerInstance database
                }

                # --- Verknüpfungen (Deployment-spezifisch) ---

                # Der User greift auf den ALB zu (Infrastruktur)
                user -> alb "HTTPS Requests an"

                # Der ALB verteilt auf die konkreten Instanzen
                alb -> webappInstance1 "Forwarded zu"
                alb -> webappInstance2 "Forwarded zu"
                alb -> webappInstance3 "Forwarded zu"

                # Security Group Logik (visuelle Darstellung der Absicherung)
                webSg -> alb "Schützt"
                dbSg -> dbInstance "Schützt"
            }
        }
    }
}