# Static Website Hosting using Terraform

<div align="center">
  <img src="https://raw.githubusercontent.com/hashicorp/terraform/main/website/public/img/logo-hashicorp.svg" alt="Terraform Logo" width="100" height="100">
  <img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" alt="AWS Logo" width="100" height="50">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/html5/html5-original.svg" alt="HTML5 Logo" width="50" height="50">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/css3/css3-original.svg" alt="CSS3 Logo" width="50" height="50">
</div>

<div align="center">
  <h3>🚀 Infrastructure as Code | ☁️ Cloud Hosting | 📱 Responsive Design</h3>
</div>

---

## Project Overview

This project demonstrates how to host a static website on AWS S3 using Terraform Infrastructure as Code (IaC). The project includes a professional resume website with modern CSS styling, deployed entirely through Terraform automation.

## Architecture

<div align="center">
  <img src="https://via.placeholder.com/800x400/2C3E50/FFFFFF?text=Architecture+Diagram" alt="Architecture Placeholder">
</div>

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                TERRAFORM WORKFLOW                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  Developer  ──terraform plan──▶  ┌─────────────────┐  ──creates──▶  AWS Cloud │
│     │                            │   Terraform     │                     │      │
│     │                            │   State         │                     │      │
│     │                            │   Management    │                     │      │
│     │                            └─────────────────┘                     │      │
│     │                                     │                              │      │
│     └──terraform apply──▶ ┌─────────────────┐  ──deploys──▶  ┌─────────────────┐│
│                           │   Infrastructure │                │   S3 Bucket     ││
│                           │   as Code (IaC)  │                │   Static Website││
│                           └─────────────────┘                └─────────────────┘│
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              WEBSITE ARCHITECTURE                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  Internet Users  ──HTTP──▶  ┌─────────────────┐  ──serves──▶  ┌───────────────┐ │
│                             │   AWS S3        │               │ Static Files  │ │
│                             │   Bucket        │               │ • index.html  │ │
│                             │   (Web Hosting) │               │ • style.css   │ │
│                             └─────────────────┘               └───────────────┘ │
│                                     │                                           │
│                                     │                                           │
│                              ┌─────────────────┐                               │
│                              │   Bucket Policy │                               │
│                              │   (Public Read) │                               │
│                              └─────────────────┘                               │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Features

- **Infrastructure as Code**: Complete AWS infrastructure defined in Terraform
- **Automated Deployment**: Single command deployment of website and infrastructure
- **Public Access**: Properly configured S3 bucket policies for public web access
- **Modern Design**: Responsive resume website with professional styling
- **Cost Effective**: Serverless architecture with minimal AWS costs

## Prerequisites

Before running this project, ensure you have:

1. **AWS CLI** installed and configured
   ```bash
   aws configure
   ```

2. **Terraform** installed (version 1.0+)
   ```bash
   terraform --version
   ```

3. **AWS Account** with appropriate permissions:
   - S3 bucket creation and management
   - IAM policy management
   - S3 bucket policy configuration

## Project Structure

```
static-website-hosting/
├── README.md              # This documentation
├── main.tf               # Main Terraform configuration
├── provider.tf           # AWS provider configuration
├── index.html            # Website HTML content
└── style.css             # Website CSS styling
```

**Note**: After running `terraform init` and `terraform apply`, Terraform will create additional files:
- `.terraform/` - Terraform working directory
- `terraform.tfstate` - Terraform state file
- `terraform.tfstate.backup` - State backup file
- `.terraform.lock.hcl` - Provider version lock file

## Configuration Files

### 1. Provider Configuration (`provider.tf`)

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0-beta3"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  profile = "default"
}
```

### 2. Main Infrastructure (`main.tf`)

The main configuration includes:

- **S3 Bucket**: Container for website files
- **Website Configuration**: Enables S3 static website hosting
- **Public Access Block**: Configures public access settings
- **Bucket Policy**: Allows public read access to website files
- **File Uploads**: Automated upload of HTML and CSS files
- **Outputs**: Website URL and bucket information

## Key Components

### S3 Bucket Resource
```hcl
resource "aws_s3_bucket" "static_site" {
  bucket = "ujwal-resume1"
  tags = {
    Name        = "StaticSiteBucket"
    Environment = "Dev"
  }
}
```

### Website Configuration
```hcl
resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.static_site.id
  index_document {
    suffix = "index.html"
  }
}
```

### Public Access Configuration
```hcl
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.static_site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```

### Bucket Policy for Public Access
```hcl
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.static_site.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = ["s3:GetObject"],
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.block]
}
```

## Website Content

### HTML Structure
The `index.html` file contains:
- Professional resume layout
- Contact information with Font Awesome icons
- Skills organized in categories
- Project descriptions
- Education details
- Responsive design elements

### CSS Styling
The `style.css` file includes:
- Modern gradient header design
- Responsive grid layouts
- Professional color scheme
- Hover effects and transitions
- Print-friendly styles
- Mobile-responsive design

## Deployment Instructions

### 🚀 Deployment Workflow

<div align="center">
  <img src="https://via.placeholder.com/800x200/3498DB/FFFFFF?text=Deployment+Workflow" alt="Deployment Workflow">
</div>

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                             DEPLOYMENT PROCESS                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  Step 1: Setup     Step 2: Initialize    Step 3: Plan      Step 4: Deploy     │
│  ┌─────────────┐   ┌─────────────────┐   ┌─────────────┐   ┌─────────────────┐ │
│  │   Create    │──▶│  terraform init │──▶│terraform plan│──▶│ terraform apply │ │
│  │ Directory   │   │                 │   │             │   │                 │ │
│  │ Add Files   │   │ Download        │   │ Review      │   │ Create          │ │
│  └─────────────┘   │ Providers       │   │ Changes     │   │ Resources       │ │
│                    └─────────────────┘   └─────────────┘   └─────────────────┘ │
│                                                                                 │
│  Step 5: Verify    Step 6: Access       Step 7: Manage     Step 8: Cleanup    │
│  ┌─────────────┐   ┌─────────────────┐   ┌─────────────┐   ┌─────────────────┐ │
│  │   Check     │   │   Open Website  │   │   Monitor   │   │terraform destroy│ │
│  │ Resources   │   │   Test Features │   │   Update    │   │                 │ │
│  │ Validate    │   │                 │   │   Scale     │   │ Remove All      │ │
│  └─────────────┘   └─────────────────┘   └─────────────┘   └─────────────────┘ │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### Step 1: Clone and Setup
```bash
# Clone the repository or create project directory
mkdir static-website-hosting
cd static-website-hosting

# Ensure your files are in place
ls -la
# Should show: README.md, main.tf, provider.tf, index.html, style.css
```

### Step 2: Initialize Terraform
```bash
terraform init
```

### Step 3: Plan the Deployment
```bash
terraform plan
```

### Step 4: Deploy Infrastructure
```bash
terraform apply
```

### Step 5: Access Your Website
After successful deployment, Terraform will output the website URL:
```
website_url = "http://ujwal-resume1.s3-website.ap-south-1.amazonaws.com"
```

## Verification Steps

### 1. Check S3 Bucket
```bash
aws s3 ls s3://ujwal-resume1/
```
Expected output:
```
2025-07-06 16:43:00       5890 index.html
2025-07-06 16:43:00       4676 style.css
```

### 2. Test Website Access
Open the website URL in your browser and verify:
- Page loads correctly
- CSS styling is applied
- All sections are visible
- Links work properly

### 3. Verify Terraform State
```bash
terraform show
terraform output
```

## Troubleshooting

### Common Issues

1. **CSS File Not Uploading**
   - Ensure `style.css` exists in the same directory as `main.tf`
   - Check file permissions
   - Verify filename spelling (case-sensitive)

2. **Access Denied Errors**
   - Verify AWS credentials are configured
   - Check IAM permissions for S3 operations
   - Ensure bucket policy is applied correctly

3. **Website Not Loading**
   - Confirm bucket policy allows public access
   - Check if public access block settings are correct
   - Verify website configuration is enabled

### Debugging Commands
```bash
# Check Terraform state
terraform state list

# View specific resource
terraform state show aws_s3_bucket.static_site

# Check AWS CLI access
aws sts get-caller-identity

# List S3 buckets
aws s3 ls
```

## Security Considerations

1. **Public Access**: The bucket is configured for public read access, which is required for web hosting
2. **Bucket Policy**: Restricts access to read-only operations
3. **No Sensitive Data**: Only static website files are stored
4. **Region Specific**: Resources are created in ap-south-1 region

## Cost Optimization

- **S3 Storage**: Pay only for storage used (~10KB for this project)
- **Data Transfer**: First 100GB/month free
- **Requests**: Minimal cost for GET requests
- **No Compute**: Serverless architecture eliminates EC2 costs

## Cleanup

To remove all resources and avoid charges:
```bash
terraform destroy
```

## Future Enhancements

1. **Custom Domain**: Add Route 53 for custom domain
2. **HTTPS**: Implement CloudFront with SSL certificate
3. **CI/CD**: Add GitHub Actions for automated deployment
4. **Monitoring**: Add CloudWatch for access logs
5. **CDN**: Implement CloudFront for global content delivery

## Technologies Used

<div align="center">
  <table>
    <tr>
      <td align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/terraform/terraform-original.svg" width="50" height="50"><br><strong>Terraform</strong><br>Infrastructure as Code</td>
      <td align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/amazonwebservices/amazonwebservices-original.svg" width="50" height="50"><br><strong>AWS S3</strong><br>Static Website Hosting</td>
      <td align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/html5/html5-original.svg" width="50" height="50"><br><strong>HTML5</strong><br>Website Structure</td>
      <td align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/css3/css3-original.svg" width="50" height="50"><br><strong>CSS3</strong><br>Modern Styling</td>
    </tr>
    <tr>
      <td align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/git/git-original.svg" width="50" height="50"><br><strong>Git</strong><br>Version Control</td>
      <td align="center"><img src="https://upload.wikimedia.org/wikipedia/commons/c/c2/Font_Awesome_5_brands_font-awesome.svg" width="50" height="50"><br><strong>Font Awesome</strong><br>Professional Icons</td>
      <td align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/vscode/vscode-original.svg" width="50" height="50"><br><strong>VS Code</strong><br>Development Environment</td>
      <td align="center"><img src="https://upload.wikimedia.org/wikipedia/commons/9/9a/Visual_Studio_Code_1.35_icon.svg" width="50" height="50"><br><strong>Terminal</strong><br>Command Line Interface</td>
    </tr>
  </table>
</div>

### Technology Stack Benefits

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              TECHNOLOGY BENEFITS                                │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  🏗️ Terraform        │  ☁️ AWS S3           │  🌐 HTML5/CSS3      │  🔧 DevOps     │
│  ─────────────────   │  ─────────────────   │  ─────────────────  │  ─────────────│
│  • Reproducible     │  • 99.99% Uptime     │  • Modern Design   │  • Automation │
│  • Version Control  │  • Global CDN        │  • Responsive       │  • Scalability│
│  • State Management │  • Pay-as-you-go     │  • SEO Friendly     │  • Monitoring │
│  • Infrastructure   │  • Security Features │  • Fast Loading     │  • CI/CD Ready│
│    as Code          │  • Easy Scaling      │  • Cross-browser    │  • Best       │
│                     │                      │    Compatible       │    Practices  │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Project Benefits

<div align="center">
  <img src="https://via.placeholder.com/800x300/27AE60/FFFFFF?text=Project+Benefits+%26+Features" alt="Project Benefits">
</div>

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                PROJECT BENEFITS                                 │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  🚀 SCALABILITY           💰 COST-EFFECTIVE         🔒 SECURITY                │
│  ─────────────────        ─────────────────         ─────────────────          │
│  • Handle high traffic    • Pay only for usage      • AWS security features    │
│  • Auto-scaling S3        • No server maintenance   • Bucket policies          │
│  • Global availability    • Minimal monthly costs   • Public read-only access  │
│  • 99.99% uptime SLA      • Free tier eligible      • No sensitive data        │
│                                                                                 │
│  ⚡ PERFORMANCE           🔧 AUTOMATION              📊 MONITORING               │
│  ─────────────────        ─────────────────         ─────────────────          │
│  • Fast content delivery  • Infrastructure as Code  • AWS CloudWatch           │
│  • Optimized for static   • Single command deploy   • Access logs              │
│  • CDN integration ready  • Version controlled      • Performance metrics      │
│  • Minimal latency        • Reproducible builds     • Error tracking           │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### Key Features

- ✅ **Scalability**: S3 can handle high traffic loads
- ✅ **Reliability**: 99.999999999% (11 9's) of durability  
- ✅ **Cost-Effective**: Pay only for what you use
- ✅ **Automation**: Complete infrastructure automation
- ✅ **Version Control**: Infrastructure changes tracked in Git

## Learning Outcomes

This project demonstrates:
- Terraform basics and AWS provider usage
- S3 static website hosting configuration
- Public access policies and security
- Infrastructure as Code best practices
- Modern web development techniques

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review AWS S3 documentation
3. Consult Terraform AWS provider documentation
4. Verify AWS CLI configuration

---

<div align="center">
  <h2>🏆 Project Showcase</h2>
  <p><strong>Professional Static Website Hosting with Modern DevOps Practices</strong></p>
  
  <img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform">
  <img src="https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white" alt="AWS">
  <img src="https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white" alt="HTML5">
  <img src="https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white" alt="CSS3">
  
  <br><br>
  
  <table>
    <tr>
      <td><strong>🔧 Author</strong></td>
      <td>Ujwal Nagrikar</td>
    </tr>
    <tr>
      <td><strong>📧 Contact</strong></td>
      <td>ujjwalnagrikar@mail.com</td>
    </tr>
    <tr>
      <td><strong>🌐 GitHub</strong></td>
      <td><a href="https://github.com/UjwalNagrikar">https://github.com/UjwalNagrikar</a></td>
    </tr>
    <tr>
      <td><strong>📁 Project</strong></td>
      <td>Static Website Hosting using Terraform</td>
    </tr>
  </table>
  
  <br>
  
  <p>
    <strong>⭐ If you found this project helpful, please give it a star! ⭐</strong>
  </p>
</div>
