//
//  ╔══════════════════════════════════════════════════════════════════════════════════════╗
//  ║                                                                                      ║
//  ║                     CFK06: Warehouse items list page (main page)                     ║
//  ║                                                                                      ║
//  ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// File: src/pages/warehouse-items.tsx
//
// Main landing page. Displays all warehouse items in a table.
// Data source: Udpp_warehouseitemsService.getAll() with react-query.
//
// Table columns: Name (link to detail) | Available Qty (right-aligned, mono) | Package Type (badge) | Status (badge) | Created (date)
// Query key: ["warehouseItems"], ordered by udpp_name asc.
//
// Features:
//   - Item name is a <Link> to /items/:id (detail page)
//   - "New Item" button opens Dialog with creation form
//   - Form fields: Name (text), Available Quantity (number), Package Type (select from packageTypeOptions)
//   - On submit: creates item via Udpp_warehouseitemsService.create()
//   - Refresh button to invalidate and refetch items
//   - Loading state with 5 skeleton rows, error banner on failure
//   - Toast notifications on success/error
//
// Selected fields: Udpp_warehouseitemid, udpp_name, udpp_availablequantity, udpp_packagetype, createdon, statecode
//

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Link } from "react-router-dom";
import { Udpp_warehouseitemsService } from "@/generated/services/Udpp_warehouseitemsService";
import type { Udpp_warehouseitems } from "@/generated/models/Udpp_warehouseitemsModel";
import { packageTypeLabels, packageTypeOptions } from "@/utils/optionSets";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { toast } from "sonner";
import { Package, Plus, RefreshCw } from "lucide-react";

export default function WarehouseItemsPage() {
  const queryClient = useQueryClient();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [name, setName] = useState("");
  const [quantity, setQuantity] = useState("");
  const [packageType, setPackageType] = useState("");

  const { data: items, isLoading, error } = useQuery({
    queryKey: ["warehouseItems"],
    queryFn: async () => {
      const result = await Udpp_warehouseitemsService.getAll({
        select: [
          "udpp_warehouseitemid",
          "udpp_name",
          "udpp_availablequantity",
          "udpp_packagetype",
          "createdon",
          "statecode",
        ],
        orderBy: ["udpp_name asc"],
      });
      console.log("[WarehouseItems] getAll result:", JSON.stringify(result));
      return result.data ?? [];
    },
  });

  const createMutation = useMutation({
    mutationFn: async () => {
      return Udpp_warehouseitemsService.create({
        udpp_name: name,
        udpp_availablequantity: quantity,
        udpp_packagetype: Number(packageType) as any,
      } as any);
    },
    onSuccess: async () => {
      await queryClient.refetchQueries({ queryKey: ["warehouseItems"] });
      toast.success("Item created successfully");
      resetForm();
    },
    onError: (err) => {
      toast.error("Failed to create item: " + String(err));
    },
  });

  const resetForm = () => {
    setDialogOpen(false);
    setName("");
    setQuantity("");
    setPackageType("");
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name || !quantity || !packageType) {
      toast.error("Please fill all required fields");
      return;
    }
    createMutation.mutate();
  };

  return (
    <div className="p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Package className="h-8 w-8 text-primary" />
          <div>
            <h1 className="text-2xl font-semibold tracking-tight">
              Warehouse Items
            </h1>
            <p className="text-sm text-muted-foreground">
              Manage your warehouse inventory
            </p>
          </div>
        </div>
        <div className="flex gap-2">
          <Button
            variant="outline"
            size="icon"
            onClick={() =>
              queryClient.invalidateQueries({ queryKey: ["warehouseItems"] })
            }
          >
            <RefreshCw className="h-4 w-4" />
          </Button>
          <Button onClick={() => setDialogOpen(true)}>
            <Plus className="h-4 w-4 mr-2" />
            New Item
          </Button>
        </div>
      </div>

      {error && (
        <div className="rounded-md bg-destructive/10 p-4 text-destructive text-sm">
          Failed to load items: {String(error)}
        </div>
      )}

      <div className="rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead className="text-right">Available Qty</TableHead>
              <TableHead>Package Type</TableHead>
              <TableHead>Status</TableHead>
              <TableHead>Created</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              Array.from({ length: 5 }).map((_, i) => (
                <TableRow key={i}>
                  {Array.from({ length: 5 }).map((_, j) => (
                    <TableCell key={j}>
                      <Skeleton className="h-4 w-full" />
                    </TableCell>
                  ))}
                </TableRow>
              ))
            ) : items && items.length > 0 ? (
              items.map((item: Udpp_warehouseitems) => (
                <TableRow key={item.udpp_warehouseitemid}>
                  <TableCell>
                    <Link
                      to={`/items/${item.udpp_warehouseitemid}`}
                      className="font-medium text-primary hover:underline"
                    >
                      {item.udpp_name}
                    </Link>
                  </TableCell>
                  <TableCell className="text-right font-mono">
                    {item.udpp_availablequantity}
                  </TableCell>
                  <TableCell>
                    <Badge variant="secondary">
                      {packageTypeLabels[
                        item.udpp_packagetype as keyof typeof packageTypeLabels
                      ] ?? item.udpp_packagetype}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    <Badge
                      variant={
                        item.statecode === 0 ? "default" : "destructive"
                      }
                    >
                      {item.statecode === 0 ? "Active" : "Inactive"}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    {item.createdon
                      ? new Date(item.createdon).toLocaleDateString()
                      : "—"}
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={5} className="text-center py-8 text-muted-foreground">
                  No warehouse items found
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </div>

      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Create New Item</DialogTitle>
          </DialogHeader>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="name">Name *</Label>
              <Input
                id="name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Enter item name"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="quantity">Available Quantity *</Label>
              <Input
                id="quantity"
                type="number"
                min="0"
                value={quantity}
                onChange={(e) => setQuantity(e.target.value)}
                placeholder="0"
              />
            </div>
            <div className="space-y-2">
              <Label>Package Type *</Label>
              <Select value={packageType} onValueChange={setPackageType}>
                <SelectTrigger>
                  <SelectValue placeholder="Select package type" />
                </SelectTrigger>
                <SelectContent>
                  {packageTypeOptions.map((opt) => (
                    <SelectItem key={opt.value} value={String(opt.value)}>
                      {opt.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <DialogFooter>
              <Button
                type="button"
                variant="outline"
                onClick={resetForm}
              >
                Cancel
              </Button>
              <Button type="submit" disabled={createMutation.isPending}>
                {createMutation.isPending ? "Creating..." : "Create"}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
}