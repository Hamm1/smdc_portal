// tests/add-button.spec.ts
import { test, expect } from '@playwright/test';

test('ADD button should be visible and clickable', async ({ page }) => {
  // Navigate to your application
  await page.goto('http://localhost:5173/');
  
  // Check if the ADD button exists and is visible
  const addButton = page.locator('button.btn:has-text("ADD")');
  await expect(addButton).toBeVisible();
  
  // Click the ADD button and verify the dialog appears
  await addButton.click();
  
  // Check if the dialog is visible
  const dialog = page.locator('dialog.modal');
  await expect(dialog).toBeVisible();
  
  // Verify dialog content
  await expect(dialog.locator('h3.font-bold')).toHaveText('Links');
  await expect(dialog.locator('p.py-4')).toContainText('Add a Title and URL');
  
  // Check for input fields
  await expect(dialog.locator('#input_title')).toBeVisible();
  await expect(dialog.locator('#input_url')).toBeVisible();
  
  // Check for Submit button
  await expect(dialog.locator('button.btn-info')).toHaveText('Submit');
  
  // Close the dialog
  await dialog.locator('button.btn-circle:has-text("✕")').click();
  
  // Verify dialog is closed
  await expect(dialog).not.toBeVisible();
});