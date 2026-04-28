//
//  ╔══════════════════════════════════════════════════════════════════════════════════════╗
//  ║                                                                                      ║
//  ║                            CFK04: Transactions list page                             ║
//  ║                                                                                      ║
//  ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// File: src/pages/transactions.tsx
//
// Displays all warehouse transactions in a sortable table.
// Data source: Udpp_warehousetransactionsService.getAll() with react-query.
//
// Table columns: Name | Quantity (right-aligned, mono) | Payment Method (badge) | Status (badge) | Date
// Query key: ["allTransactions"], ordered by createdon desc.
//
// Features:
//   - "New Transaction" button opens a Dialog with a creation form
//   - Form fields: Name (text), Warehouse Item (select from items lookup), Quantity (number), Payment Method (select)
//   - Items lookup: fetches active items via Udpp_warehouseitemsService.getAll() with queryKey ["warehouseItemsLookup"]
//   - On submit: creates transaction via Udpp_warehousetransactionsService.create()
//   - Links item via udpp_itemid@odata.bind navigation property
//   - Refresh button to refetch transactions
//   - Loading state with skeleton rows, error banner on failure
//   - Toast notifications on success/error
//

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Udpp_warehousetransactionsService } from "@/generated/services/Udpp_warehousetransactionsService";
import { Udpp_warehouseitemsService } from "@/generated/services/Udpp_warehouseitemsService";
import type { Udpp_warehousetransactions } from "@/generated/models/Udpp_warehousetransactionsModel";
import type { Udpp_warehouseitems } from "@/generated/models/Udpp_warehouseitemsModel";
import { paymentMethodLabels, paymentMethodOptions } from "@/utils/optionSets";
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
import { ArrowRightLeft, Plus, RefreshCw } from "lucide-react";

export default function TransactionsPage() {
  const queryClient = useQueryClient();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [txName, setTxName] = useState("");
  const [txQuantity, setTxQuantity] = useState("");
  const [txPaymentMethod, setTxPaymentMethod] = useState("");
  const [txItemId, setTxItemId] = useState("");

  const { data: transactions, isLoading, error } = useQuery({
    queryKey: ["allTransactions"],
    queryFn: async () => {
      const result = await Udpp_warehousetransactionsService.getAll({
        select: [
          "udpp_warehousetransactionid",
          "udpp_name",
          "udpp_quantity",
          "udpp_paymentmethod",
          "createdon",
          "statecode",
        ],
        orderBy: ["createdon desc"],
      });
      return result.data ?? [];
    },
  });

  const { data: items } = useQuery({
    queryKey: ["warehouseItemsLookup"],
    queryFn: async () => {
      const result = await Udpp_warehouseitemsService.getAll({
        select: ["udpp_warehouseitemid", "udpp_name"],
        filter: "statecode eq 0",
        orderBy: ["udpp_name asc"],
      });
      return result.data ?? [];
    },
  });

  const createMutation = useMutation({
    mutationFn: async () => {
      return Udpp_warehousetransactionsService.create({
        udpp_name: txName,
        udpp_quantity: txQuantity,
        udpp_paymentmethod: Number(txPaymentMethod) as any,
        "udpp_itemid@odata.bind": `/Udpp_warehouseitems(${txItemId})`,
      } as any);
    },
    onSuccess: async () => {
      await queryClient.refetchQueries({ queryKey: ["allTransactions"] });
      toast.success("Transaction created successfully");
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
    setTxItemId("");
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!txName || !txQuantity || !txPaymentMethod || !txItemId) {
      toast.error("Please fill all required fields");
      return;
    }
    createMutation.mutate();
  };

  return (
    <div className="p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <ArrowRightLeft className="h-8 w-8 text-primary" />
          <div>
            <h1 className="text-2xl font-semibold tracking-tight">
              Transactions
            </h1>
            <p className="text-sm text-muted-foreground">
              All warehouse transactions
            </p>
          </div>
        </div>
        <div className="flex gap-2">
          <Button
            variant="outline"
            size="icon"
            onClick={() =>
              queryClient.refetchQueries({ queryKey: ["allTransactions"] })
            }
          >
            <RefreshCw className="h-4 w-4" />
          </Button>
          <Button onClick={() => setDialogOpen(true)}>
            <Plus className="h-4 w-4 mr-2" />
            New Transaction
          </Button>
        </div>
      </div>

      {error && (
        <div className="rounded-md bg-destructive/10 p-4 text-destructive text-sm">
          Failed to load transactions: {String(error)}
        </div>
      )}

      <div className="rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead className="text-right">Quantity</TableHead>
              <TableHead>Payment Method</TableHead>
              <TableHead>Status</TableHead>
              <TableHead>Date</TableHead>
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
            ) : transactions && transactions.length > 0 ? (
              transactions.map((tx: Udpp_warehousetransactions) => (
                <TableRow key={tx.udpp_warehousetransactionid}>
                  <TableCell className="font-medium">{tx.udpp_name}</TableCell>
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
                  <TableCell>
                    <Badge
                      variant={tx.statecode === 0 ? "default" : "destructive"}
                    >
                      {tx.statecode === 0 ? "Active" : "Inactive"}
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
                  colSpan={5}
                  className="text-center py-8 text-muted-foreground"
                >
                  No transactions found
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </div>

      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Create New Transaction</DialogTitle>
          </DialogHeader>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="txName">Name *</Label>
              <Input
                id="txName"
                value={txName}
                onChange={(e) => setTxName(e.target.value)}
                placeholder="Enter transaction name"
              />
            </div>
            <div className="space-y-2">
              <Label>Warehouse Item *</Label>
              <Select value={txItemId} onValueChange={setTxItemId}>
                <SelectTrigger>
                  <SelectValue placeholder="Select item" />
                </SelectTrigger>
                <SelectContent>
                  {(items ?? []).map((item: Udpp_warehouseitems) => (
                    <SelectItem
                      key={item.udpp_warehouseitemid}
                      value={item.udpp_warehouseitemid}
                    >
                      {item.udpp_name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
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