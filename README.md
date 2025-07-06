# Static Website Hosting using Terraform

## Project Overview

This project demonstrates how to host a static website on AWS S3 using Terraform Infrastructure as Code (IaC). The project includes a professional resume website with modern CSS styling, deployed entirely through Terraform automation.

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Internet      │    │   AWS S3        │    │   Static Files  │
│   Users         │───▶│   Bucket        │───▶│   index.html    │
│                 │    │   (Web Hosting) │    │   style.css     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
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
├── style.css             # Website CSS styling
├── .terraform/           # Terraform working directory
├── terraform.tfstate     # Terraform state file
└── terraform.tfstate.backup  # State backup
```

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

### Step 1: Clone and Setup
```bash
# Clone the repository
git clone <repository-url>
cd static-website-hosting

# Ensure your files are in place
ls -la
# Should show: main.tf, provider.tf, index.html, style.css
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

- **Terraform**: Infrastructure as Code
- **AWS S3**: Static website hosting
- **HTML5**: Website structure
- **CSS3**: Modern styling with gradients and animations
- **Font Awesome**: Professional icons
- **Git**: Version control

## Project Benefits

1. **Scalability**: S3 can handle high traffic loads
2. **Reliability**: 99.999999999% (11 9's) of durability
3. **Cost-Effective**: Pay only for what you use
4. **Automation**: Complete infrastructure automation
5. **Version Control**: Infrastructure changes tracked in Git

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

**Author**: Ujwal Nagrikar  
**Contact**: ujjwalnagrikar@mail.com  
**GitHub**: https://github.com/UjwalNagrikar  
**Project**: Static Website Hosting using Terraform
