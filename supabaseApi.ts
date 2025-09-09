import { supabase } from './supabaseClient';
import type {
  Client,
  Project,
  AddOn,
  AssignedTeamMember,
  Revision,
  PrintingItem,
  Transaction,
  Package,
  Card,
  FinancialPocket,
  Lead,
  Asset,
  PromoCode,
  SOP,
  Contract,
  TeamMember,
  TeamProjectPayment,
  TeamPaymentRecord,
  RewardLedgerEntry,
  ClientFeedback,
  Notification,
  SocialMediaPost,
  Profile,
} from './types';

// Helper: shallow map camelCase -> snake_case for plain objects
const toSnake = (obj: Record<string, any>) => {
  const out: Record<string, any> = {};
  for (const [k, v] of Object.entries(obj)) {
    const snake = k
      .replace(/([A-Z])/g, '_$1')
      .replace(/__/g, '_')
      .toLowerCase();
    out[snake] = v;
  }
  return out;
};

// region: Entity mappers

const clientToRow = (c: Client) => ({
  id: c.id,
  name: c.name,
  email: c.email,
  phone: c.phone,
  whatsapp: c.whatsapp ?? null,
  since: c.since ? c.since : null,
  instagram: c.instagram ?? null,
  status: c.status,
  client_type: c.clientType,
  last_contact: c.lastContact ?? null,
  portal_access_id: c.portalAccessId ?? null,
});

const projectToRow = (p: Project) => ({
  id: p.id,
  project_name: p.projectName,
  client_name: p.clientName,
  client_id: p.clientId ?? null,
  project_type: p.projectType,
  package_name: p.packageName ?? null,
  package_id: p.packageId ?? null,
  date: p.date ?? null,
  deadline_date: p.deadlineDate ?? null,
  location: p.location ?? null,
  progress: p.progress ?? 0,
  status: p.status,
  active_sub_statuses: p.activeSubStatuses ?? [],
  total_cost: p.totalCost ?? 0,
  amount_paid: p.amountPaid ?? 0,
  payment_status: p.paymentStatus,
  notes: p.notes ?? null,
  accommodation: p.accommodation ?? null,
  drive_link: p.driveLink ?? null,
  client_drive_link: p.clientDriveLink ?? null,
  final_drive_link: p.finalDriveLink ?? null,
  start_time: p.startTime ?? null,
  end_time: p.endTime ?? null,
  promo_code_id: p.promoCodeId ?? null,
  discount_amount: p.discountAmount ?? null,
  shipping_details: p.shippingDetails ?? null,
  dp_proof_url: p.dpProofUrl ?? null,
  printing_cost: p.printingCost ?? null,
  transport_cost: p.transportCost ?? null,
  is_editing_confirmed_by_client: p.isEditingConfirmedByClient ?? null,
  is_printing_confirmed_by_client: p.isPrintingConfirmedByClient ?? null,
  is_delivery_confirmed_by_client: p.isDeliveryConfirmedByClient ?? null,
  confirmed_sub_statuses: p.confirmedSubStatuses ?? [],
  client_sub_status_notes: p.clientSubStatusNotes ?? {},
  sub_status_confirmation_sent_at: p.subStatusConfirmationSentAt ?? {},
  completed_digital_items: p.completedDigitalItems ?? [],
  invoice_signature: p.invoiceSignature ?? null,
  custom_sub_statuses: p.customSubStatuses ?? [],
  booking_status: p.bookingStatus ?? null,
  rejection_reason: p.rejectionReason ?? null,
  chat_history: p.chatHistory ?? [],
});

const revisionToRow = (projId: string, r: Revision) => ({
  id: r.id,
  project_id: projId,
  date: r.date ?? null,
  admin_notes: r.adminNotes ?? null,
  deadline: r.deadline ?? null,
  freelancer_id: r.freelancerId ?? null,
  status: r.status,
  freelancer_notes: r.freelancerNotes ?? null,
  drive_link: r.driveLink ?? null,
  completed_date: r.completedDate ?? null,
});

const printingItemToRow = (projId: string, i: PrintingItem) => ({
  id: i.id,
  project_id: projId,
  item_type: i.type,
  custom_name: i.customName ?? null,
  details: i.details ?? null,
  cost: i.cost ?? 0,
});

const transactionToRow = (t: Transaction) => ({
  id: t.id,
  date: t.date ?? null,
  description: t.description ?? null,
  amount: t.amount ?? 0,
  type: t.type,
  project_id: t.projectId ?? null,
  category: t.category,
  method: t.method,
  pocket_id: t.pocketId ?? null,
  card_id: t.cardId ?? null,
  printing_item_id: t.printingItemId ?? null,
  vendor_signature: t.vendorSignature ?? null,
});

const packageToRow = (p: Package) => ({
  id: p.id,
  name: p.name,
  price: p.price,
  category: p.category,
  physical_items: p.physicalItems ?? [],
  digital_items: p.digitalItems ?? [],
  processing_time: p.processingTime ?? null,
  default_printing_cost: p.defaultPrintingCost ?? null,
  default_transport_cost: p.defaultTransportCost ?? null,
  photographers: p.photographers ?? null,
  videographers: p.videographers ?? null,
  cover_image: p.coverImage ?? null,
});

const addOnToRow = (a: AddOn) => ({ id: a.id, name: a.name, price: a.price });

const cardToRow = (c: Card) => ({
  id: c.id,
  card_holder_name: c.cardHolderName,
  bank_name: c.bankName,
  card_type: c.cardType,
  last_four_digits: c.lastFourDigits,
  expiry_date: c.expiryDate ?? null,
  balance: c.balance ?? 0,
  color_gradient: c.colorGradient ?? null,
});

const pocketToRow = (p: FinancialPocket) => ({
  id: p.id,
  name: p.name,
  description: p.description ?? null,
  icon: p.icon,
  type: p.type,
  amount: p.amount ?? 0,
  goal_amount: p.goalAmount ?? null,
  lock_end_date: p.lockEndDate ?? null,
  members: p.members ?? [],
  source_card_id: p.sourceCardId ?? null,
});

const leadToRow = (l: Lead) => ({
  id: l.id,
  name: l.name,
  contact_channel: l.contactChannel,
  location: l.location ?? null,
  status: l.status,
  date: l.date ?? null,
  notes: l.notes ?? null,
  whatsapp: l.whatsapp ?? null,
});

const assetToRow = (a: Asset) => ({
  id: a.id,
  name: a.name,
  category: a.category,
  purchase_date: a.purchaseDate ?? null,
  purchase_price: a.purchasePrice ?? 0,
  serial_number: a.serialNumber ?? null,
  status: a.status,
  notes: a.notes ?? null,
});

const promoCodeToRow = (p: PromoCode) => ({
  id: p.id,
  code: p.code,
  discount_type: p.discountType,
  discount_value: p.discountValue,
  is_active: p.isActive,
  usage_count: p.usageCount,
  max_usage: p.maxUsage ?? null,
  expiry_date: p.expiryDate ?? null,
  created_at: p.createdAt ?? null,
});

const sopToRow = (s: SOP) => ({
  id: s.id,
  title: s.title,
  category: s.category,
  content: s.content,
  last_updated: s.lastUpdated ?? null,
});

const contractToRow = (c: Contract) => ({
  id: c.id,
  contract_number: c.contractNumber,
  client_id: c.clientId ?? null,
  project_id: c.projectId ?? null,
  signing_date: c.signingDate ?? null,
  signing_location: c.signingLocation ?? null,
  created_at: c.createdAt ?? null,
  client_name1: c.clientName1 ?? null,
  client_address1: c.clientAddress1 ?? null,
  client_phone1: c.clientPhone1 ?? null,
  client_name2: c.clientName2 ?? null,
  client_address2: c.clientAddress2 ?? null,
  client_phone2: c.clientPhone2 ?? null,
  shooting_duration: c.shootingDuration ?? null,
  guaranteed_photos: c.guaranteedPhotos ?? null,
  album_details: c.albumDetails ?? null,
  digital_files_format: c.digitalFilesFormat ?? null,
  other_items: c.otherItems ?? null,
  personnel_count: c.personnelCount ?? null,
  delivery_timeframe: c.deliveryTimeframe ?? null,
  dp_date: c.dpDate ?? null,
  final_payment_date: c.finalPaymentDate ?? null,
  cancellation_policy: c.cancellationPolicy ?? null,
  jurisdiction: c.jurisdiction ?? null,
  vendor_signature: c.vendorSignature ?? null,
  client_signature: c.clientSignature ?? null,
});

const teamMemberToRow = (t: TeamMember) => ({
  id: t.id,
  name: t.name,
  role: t.role,
  email: t.email ?? null,
  phone: t.phone ?? null,
  standard_fee: t.standardFee ?? 0,
  norek: t.noRek ?? null,
  reward_balance: t.rewardBalance ?? 0,
  rating: t.rating ?? 0,
  performance_notes: t.performanceNotes ?? [],
  portal_access_id: t.portalAccessId ?? null,
});

const teamProjectPaymentToRow = (p: TeamProjectPayment) => ({
  id: p.id,
  project_id: p.projectId,
  team_member_name: p.teamMemberName,
  team_member_id: p.teamMemberId ?? null,
  date: p.date ?? null,
  status: p.status,
  fee: p.fee ?? 0,
  reward: p.reward ?? null,
});

const teamPaymentRecordToRow = (r: TeamPaymentRecord) => ({
  id: r.id,
  record_number: r.recordNumber,
  team_member_id: r.teamMemberId ?? null,
  date: r.date ?? null,
  total_amount: r.totalAmount ?? 0,
  vendor_signature: r.vendorSignature ?? null,
});

const feedbackToRow = (f: ClientFeedback) => ({
  id: f.id,
  client_name: f.clientName,
  satisfaction: f.satisfaction,
  rating: f.rating,
  feedback: f.feedback ?? null,
  date: f.date ?? null,
});

const notificationToRow = (n: Notification) => ({
  id: n.id,
  title: n.title,
  message: n.message,
  timestamp: n.timestamp ?? new Date().toISOString(),
  is_read: n.isRead,
  icon: n.icon,
  link: n.link ? toSnake(n.link as any) : null,
});

const postToRow = (p: SocialMediaPost) => ({
  id: p.id,
  project_id: p.projectId ?? null,
  client_name: p.clientName ?? null,
  post_type: p.postType,
  platform: p.platform,
  scheduled_date: p.scheduledDate ?? null,
  caption: p.caption ?? null,
  media_url: p.mediaUrl ?? null,
  status: p.status,
  notes: p.notes ?? null,
});

const profileToRow = (pr: Profile) => ({
  id: pr.id && pr.id.length > 0 ? pr.id : undefined,
  full_name: pr.fullName,
  email: pr.email,
  phone: pr.phone,
  company_name: pr.companyName,
  website: pr.website ?? null,
  address: pr.address ?? null,
  bank_account: pr.bankAccount ?? null,
  authorized_signer: pr.authorizedSigner ?? null,
  id_number: pr.idNumber ?? null,
  bio: pr.bio ?? null,
  income_categories: pr.incomeCategories ?? [],
  expense_categories: pr.expenseCategories ?? [],
  project_types: pr.projectTypes ?? [],
  event_types: pr.eventTypes ?? [],
  asset_categories: pr.assetCategories ?? [],
  sop_categories: pr.sopCategories ?? [],
  package_categories: pr.packageCategories ?? [],
  project_status_config: pr.projectStatusConfig ?? [],
  notification_settings: pr.notificationSettings ?? { newProject: true, paymentConfirmation: true, deadlineReminder: true },
  security_settings: pr.securitySettings ?? { twoFactorEnabled: false },
  briefing_template: pr.briefingTemplate ?? null,
  terms_and_conditions: pr.termsAndConditions ?? null,
  contract_template: pr.contractTemplate ?? null,
  logo_base64: pr.logoBase64 ?? null,
  brand_color: pr.brandColor ?? null,
  public_page_config: pr.publicPageConfig ?? { template: 'classic', title: '', introduction: '', galleryImages: [] },
  package_share_template: pr.packageShareTemplate ?? null,
  booking_form_template: pr.bookingFormTemplate ?? null,
  chat_templates: pr.chatTemplates ?? [],
});

// endregion

// region: Generic helpers

async function upsert(table: string, rows: any[]) {
  if (!rows.length) return;
  const { error } = await supabase.from(table).upsert(rows, { onConflict: 'id' });
  if (error) throw error;
}

async function deleteByIds(table: string, ids: string[]) {
  if (!ids.length) return;
  const { error } = await supabase.from(table).delete().in('id', ids);
  if (error) throw error;
}

// endregion

// region: Public API

export const supa = {
  // Basic tables
  async syncClients(current: Client[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    const rows = current.map(clientToRow);
    await upsert('clients', rows);
    if (deleted.length) await deleteByIds('clients', deleted);
    return currIds;
  },

  async syncLeads(current: Lead[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('leads', current.map(leadToRow));
    if (deleted.length) await deleteByIds('leads', deleted);
    return currIds;
  },

  async syncPackages(current: Package[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('packages', current.map(packageToRow));
    if (deleted.length) await deleteByIds('packages', deleted);
    return currIds;
  },

  async syncAddOns(current: AddOn[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('add_ons', current.map(addOnToRow));
    if (deleted.length) await deleteByIds('add_ons', deleted);
    return currIds;
  },

  async syncCards(current: Card[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('cards', current.map(cardToRow));
    if (deleted.length) await deleteByIds('cards', deleted);
    return currIds;
  },

  async syncPockets(current: FinancialPocket[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('pockets', current.map(pocketToRow));
    if (deleted.length) await deleteByIds('pockets', deleted);
    return currIds;
  },

  async syncAssets(current: Asset[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('assets', current.map(assetToRow));
    if (deleted.length) await deleteByIds('assets', deleted);
    return currIds;
  },

  async syncPromoCodes(current: PromoCode[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('promo_codes', current.map(promoCodeToRow));
    if (deleted.length) await deleteByIds('promo_codes', deleted);
    return currIds;
  },

  async syncSops(current: SOP[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('sops', current.map(sopToRow));
    if (deleted.length) await deleteByIds('sops', deleted);
    return currIds;
  },

  async syncTransactions(current: Transaction[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('transactions', current.map(transactionToRow));
    if (deleted.length) await deleteByIds('transactions', deleted);
    return currIds;
  },

  async syncContracts(current: Contract[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('contracts', current.map(contractToRow));
    if (deleted.length) await deleteByIds('contracts', deleted);
    return currIds;
  },

  async syncTeamMembers(current: TeamMember[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('team_members', current.map(teamMemberToRow));
    if (deleted.length) await deleteByIds('team_members', deleted);
    return currIds;
  },

  async syncTeamProjectPayments(current: TeamProjectPayment[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('team_project_payments', current.map(teamProjectPaymentToRow));
    if (deleted.length) await deleteByIds('team_project_payments', deleted);
    return currIds;
  },

  async syncTeamPaymentRecords(current: TeamPaymentRecord[], prevIds: Set<string>) {
    // Upsert records
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('team_payment_records', current.map(teamPaymentRecordToRow));
    if (deleted.length) await deleteByIds('team_payment_records', deleted);

    // Replace items for each record
    for (const r of current) {
      // delete all existing items for record
      await supabase.from('team_payment_record_items').delete().eq('record_id', r.id);
      // insert current items
      const items = (r.projectPaymentIds || []).map((pid) => ({ record_id: r.id, project_payment_id: pid }));
      if (items.length) {
        const { error } = await supabase.from('team_payment_record_items').insert(items);
        if (error) throw error;
      }
    }

    return currIds;
  },

  async syncClientFeedback(current: ClientFeedback[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('client_feedback', current.map(feedbackToRow));
    if (deleted.length) await deleteByIds('client_feedback', deleted);
    return currIds;
  },

  async syncNotifications(current: Notification[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('notifications', current.map(notificationToRow));
    if (deleted.length) await deleteByIds('notifications', deleted);
    return currIds;
  },

  async syncPosts(current: SocialMediaPost[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));
    await upsert('social_media_posts', current.map(postToRow));
    if (deleted.length) await deleteByIds('social_media_posts', deleted);
    return currIds;
  },

  async syncProjects(current: Project[], prevIds: Set<string>) {
    const currIds = new Set(current.map((x) => x.id));
    const deleted = [...prevIds].filter((id) => !currIds.has(id));

    // Upsert base project rows
    await upsert('projects', current.map(projectToRow));

    // For each project, replace join tables: project_add_ons, project_team
    for (const p of current) {
      // project_add_ons
      await supabase.from('project_add_ons').delete().eq('project_id', p.id);
      const addOnRows = (p.addOns || []).map((a: AddOn) => ({ project_id: p.id, add_on_id: a.id }));
      if (addOnRows.length) {
        const { error } = await supabase.from('project_add_ons').insert(addOnRows);
        if (error) throw error;
      }

      // project_team
      await supabase.from('project_team').delete().eq('project_id', p.id);
      const teamRows = (p.team || []).map((t: AssignedTeamMember) => ({
        project_id: p.id,
        member_id: t.memberId,
        name: t.name,
        role: t.role,
        fee: t.fee ?? 0,
        reward: t.reward ?? null,
        sub_job: t.subJob ?? null,
      }));
      if (teamRows.length) {
        const { error } = await supabase.from('project_team').insert(teamRows);
        if (error) throw error;
      }

      // project_revisions (replace all)
      if (p.revisions) {
        await supabase.from('project_revisions').delete().eq('project_id', p.id);
        const revRows = p.revisions.map((r) => revisionToRow(p.id, r));
        if (revRows.length) {
          const { error } = await supabase.from('project_revisions').insert(revRows);
          if (error) throw error;
        }
      }

      // printing_items (replace all)
      if (p.printingDetails) {
        await supabase.from('printing_items').delete().eq('project_id', p.id);
        const printRows = p.printingDetails.map((i) => printingItemToRow(p.id, i));
        if (printRows.length) {
          const { error } = await supabase.from('printing_items').insert(printRows);
          if (error) throw error;
        }
      }
    }

    // Handle deleted projects (cascade clean-up will delete join rows)
    if (deleted.length) await deleteByIds('projects', deleted);

    return currIds;
  },

  async upsertProfile(profile: Profile): Promise<string> {
    // returns ensured profile id
    const row = profileToRow(profile);
    const hasId = !!profile.id && profile.id.length > 0;
    if (hasId) {
      const { data, error } = await supabase.from('profiles').upsert(row).select('id').single();
      if (error) throw error;
      return data.id as string;
    }
    const { data, error } = await supabase.from('profiles').insert(row).select('id').single();
    if (error) throw error;
    return data.id as string;
  },
};
