#!/bin/bash

# Quick Deploy Script for Ceylon Footprint
# This script helps you deploy your website quickly

echo "🚀 Ceylon Footprint - Quick Deploy Script"
echo "=========================================="
echo ""

# Check if images are optimized
echo "🔍 Checking image sizes..."
large_images=$(find assets -name "*.jpg" -size +2M 2>/dev/null | wc -l)

if [ "$large_images" -gt 0 ]; then
    echo "⚠️  WARNING: Found $large_images images larger than 2MB!"
    echo ""
    echo "Your site will be SLOW without image optimization."
    echo ""
    read -p "Do you want to optimize images now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command -v node &> /dev/null; then
            echo "🔧 Running image optimization..."
            node optimize-images.js
        else
            echo "❌ Node.js not found. Please run: node optimize-images.js"
            exit 1
        fi
    else
        echo "⚠️  Proceeding without optimization (NOT RECOMMENDED)"
    fi
fi

echo ""
echo "📦 Staging all changes..."
git add .

echo ""
read -p "Enter commit message (or press Enter for default): " commit_msg

if [ -z "$commit_msg" ]; then
    commit_msg="Website optimizations and Railway deployment setup"
fi

echo ""
echo "💾 Committing changes..."
git commit -m "$commit_msg"

echo ""
echo "⬆️  Pushing to GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SUCCESS! Your code is now on GitHub!"
    echo ""
    echo "📋 Next Steps:"
    echo "1. Go to https://railway.app/"
    echo "2. Click 'New Project' → 'Deploy from GitHub'"
    echo "3. Select your Ceylon_Footprint repository"
    echo "4. Railway will auto-deploy!"
    echo ""
    echo "🌐 Your site will be live at: *.railway.app"
    echo ""
    echo "📊 After deployment, test at: https://pagespeed.web.dev/"
else
    echo ""
    echo "❌ Push failed. Please check your GitHub credentials."
fi
