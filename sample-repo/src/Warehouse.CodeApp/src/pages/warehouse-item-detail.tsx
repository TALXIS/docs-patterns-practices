//
//  ╔══════════════════════════════════════════════════════════════════════════════════════╗
//  ║                                                                                      ║
//  ║                          CFK05: Warehouse item detail page                           ║
//  ║                                                                                      ║
//  ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// File: src/pages/warehouse-item-detail.tsx
//
// Shows detailed view of a single warehouse item with its transactions.
// Route param: :id (from useParams).
//
// Data sources:
//   - Item: Udpp_warehouseitemsService.get(id), queryKey ["warehouseItem", id]
//   - Transactions: Udpp_warehousetransactionsService.getAll() filtered by _udpp_itemid_value eq id
//     queryKey ["itemTransactions", id], ordered by createdon desc
//
// Layout:
//   - Back button (arrow left) linking to / (items list)
//   - Item name as page title
//   - 3 stat cards: Available Quantity (large number), Package Type (with icon), Status (badge)
//
// Transactions section:
//   - Table columns: Name | Quantity (right-aligned, mono) | Payment Method (badge) | Date
//   - "New Transaction" button opens Dialog form
//   - Form fields: Transaction Name, Quantity, Payment Method
//   - Auto-binds to current item via udpp_itemid@odata.bind
//   - On success: refetches both item and transactions queries
//
// States: loading skeleton, item not found message, empty transactions message
//

import { useState } from "react";
import { useParams, Link } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Udpp_warehouseitemsService } from "@/generated/services/Udpp_warehouseitemsService";
import { Udpp_warehousetransactionsService } from "@/generated/services/Udpp_warehousetransactionsService";
import type { Udpp_warehousetransactions } from "@/generated/models/Udpp_warehousetransactionsModel";
import {
  packageTypeLabels,
  paymentMethodLabels,
  paymentMethodOptions,
} from "@/utils/optionSets";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
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
import { ArrowLeft, Plus, Package, ArrowRightLeft } from "lucide-react";

export default function WarehouseItemDetailPage() {
  const { id } = useParams<{ id: string }>();
  const queryClient = useQueryClient();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [txName, setTxName] = useState("");
  const [txQuantity, setTxQuantity] = useState("");
  const [txPaymentMethod, setTxPaymentMethod] = useState("");

  const { data: item, isLoading: itemLoading } = useQuery({
    queryKey: ["warehouseItem", id],
    queryFn: async () => {
      const result = await Udpp_warehouseitemsService.get(id!);
      return result.data;
    },
    enabled: !!id,
  });

  const { data: transactions, isLoading: txLoading } = useQuery({
    queryKey: ["itemTransactions", id],
    queryFn: async () => {
      const result = await Udpp_warehousetransactionsService.getAll({
        select: [
          "udpp_warehousetransactionid",
          "udpp_name",
          "udpp_quantity",
          "udpp_paymentmethod",
          "createdon",
        ],
        filter: `_udpp_itemid_value eq '${id}'`,
        orderBy: ["createdon desc"],
      });
      return result.data ?? [];
    },
    enabled: !!id,
  });

  const createTxMutation = useMutation({
    mutationFn: async () => {
      return Udpp_warehousetransactionsService.create({
        udpp_name: txName,
        udpp_quantity: txQuantity,
        udpp_paymentmethod: Number(txPaymentMethod) as any,
        "udpp_itemid@odata.bind": `/Udpp_warehouseitems(${id})`,
      } as any);
    },
    onSuccess: async () => {
      await queryClient.refetchQueries({ queryKey: ["itemTransactions", id] });
      await queryClient.refetchQueries({ queryKey: ["warehouseItem", id] });
      toast.success("Transaction created");
      resetForm();
    },
    onError: (err) => {
      toast.error("Failed to create transaction: " + String(err));
    },
  });

  const resetForm = () => {
    setDialogOpen(false);
    setTxName("");
    setTxQuantity("");
    setTxPaymentMethod("");
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!txName || !txQuantity || !txPaymentMethod) {
      toast.error("Please fill all required fields");
      return;
    }
    createTxMutation.mutate();
  };

  if (itemLoading) {
    return (
      <div className="p-6 space-y-6">
        <Skeleton className="h-8 w-48" />
        <Skeleton className="h-32 w-full" />
        <Skeleton className="h-64 w-full" />
      </div>
    );
  }

  if (!item) {
    return (
      <div className="p-6">
        <p className="text-muted-foreground">Item not found.</p>
        <Link to="/">
          <Button variant="link" className="mt-2">
            <ArrowLeft className="h-4 w-4 mr-2" /> Back to items
          </Button>
        </Link>
      </div>
    );
  }

  return (
    <div className="p-6 space-y-6">
      <div className="flex items-center gap-4">
        <Link to="/">
          <Button variant="ghost" size="icon">
            <ArrowLeft className="h-4 w-4" />
          </Button>
        </Link>
        <div>
          <h1 className="text-2xl font-semibold tracking-tight">
            {item.udpp_name}
          </h1>
          <p className="text-sm text-muted-foreground">Item details</p>
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Available Quantity
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">
              {item.udpp_availablequantity}
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Package Type
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex items-center gap-2">
              <Package className="h-5 w-5 text-muted-foreground" />
              <span className="text-lg font-medium">
                {packageTypeLabels[
                  item.udpp_packagetype as keyof typeof packageTypeLabels
                ] ?? item.udpp_packagetype}
              </span>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Status
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Badge variant={item.statecode === 0 ? "default" : "destructive"}>
              {item.statecode === 0 ? "Active" : "Inactive"}
            </Badge>
          </CardContent>
        </Card>
      </div>

      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <ArrowRightLeft className="h-5 w-5 text-muted-foreground" />
            <h2 className="text-lg font-semibold">Transactions</h2>
          </div>
          <Button size="sm" onClick={() => setDialogOpen(true)}>
            <Plus className="h-4 w-4 mr-2" />
            New Transaction
          </Button>
        </div>

        <div className="rounded-md border">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Name</TableHead>
                <TableHead className="text-right">Quantity</TableHead>
                <TableHead>Payment Method</TableHead>
                <TableHead>Date</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {txLoading ? (
                Array.from({ length: 3 }).map((_, i) => (
                  <TableRow key={i}>
                    {Array.from({ length: 4 }).map((_, j) => (
                      <TableCell key={j}>
                        <Skeleton className="h-4 w-full" />
                      </TableCell>
                    ))}
                  </TableRow>
                ))
              ) : transactions && transactions.length > 0 ? (
                transactions.map((tx: Udpp_warehousetransactions) => (
                  <TableRow key={tx.udpp_warehousetransactionid}>
                    <TableCell className="font-medium">
                      {tx.udpp_name}
                    </TableCell>
                    <TableCell className="text-right font-mono">
                      {tx.udpp_quantity}
                    </TableCell>
                    <TableCell>
                      <Badge variant="outline">
                        {paymentMethodLabels[
                          tx.udpp_paymentmethod as keyof typeof paymentMethodLabels
                        ] ?? tx.udpp_paymentmethod}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-muted-foreground">
                      {tx.createdon
                        ? new Date(tx.createdon).toLocaleDateString()
                        : "—"}
                    </TableCell>
                  </TableRow>
                ))
              ) : (
                <TableRow>
                  <TableCell
                    colSpan={4}
                    className="text-center py-8 text-muted-foreground"
                  >
                    No transactions yet
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </div>
      </div>

      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>New Transaction for {item.udpp_name}</DialogTitle>
          </DialogHeader>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="txName">Transaction Name *</Label>
              <Input
                id="txName"
                value={txName}
                onChange={(e) => setTxName(e.target.value)}
                placeholder="Enter transaction name"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="txQuantity">Quantity *</Label>
              <Input
                id="txQuantity"
                type="number"
                min="0"
                value={txQuantity}
                onChange={(e) => setTxQuantity(e.target.value)}
                placeholder="0"
              />
            </div>
            <div className="space-y-2">
              <Label>Payment Method *</Label>
              <Select
                value={txPaymentMethod}
                onValueChange={setTxPaymentMethod}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select payment method" />
                </SelectTrigger>
                <SelectContent>
                  {paymentMethodOptions.map((opt) => (
                    <SelectItem key={opt.value} value={String(opt.value)}>
                      {opt.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={resetForm}>
                Cancel
              </Button>
              <Button type="submit" disabled={createTxMutation.isPending}>
                {createTxMutation.isPending ? "Creating..." : "Create"}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
}